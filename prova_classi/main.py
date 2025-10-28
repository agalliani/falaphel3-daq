import sys
import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import csv
from typing import Tuple, Optional
# Importa AsicConfigurator (assumendo sia nel file asic_config.py)
from asic_config import AsicConfigurator
from serial_interface import SerialInterface 
from power_supply_controller import PowerSupplyService
from export_service import ExportService # Assumo che questa classe sia definita altrove
import time
import signal
import math
import statistics


USE_SERIAL = True # True per usare la porta reale, False per emulare


# ==============================================================================
# CLASSE PRINCIPALE DELL'APPLICAZIONE (GUI)
# ==============================================================================
class FpgaControlApp:
    def __init__(self, master):
        self.master = master
        master.title("UART Read/Write Tool")

        # 1. ATTRIBUTI DI STATO
        self.asic_config = AsicConfigurator()
        self.spi_initialized = False # Flag per l'inizializzazione SPI

        self.ps_service = PowerSupplyService()
        self.exporter = ExportService()
        
        # Le variabili self.tot_response e self.toa_response sono state RIMOVE 
        # perché ora i dati vengono restituiti direttamente da _inject_a_pixel.

        # 2. VARIABILI DI CONTROLLO TKINTER
        self.result_var = tk.StringVar()
        self.port_entry = tk.StringVar(value="COM3")
        self.baud_entry = tk.StringVar(value="115200")
        self.write_addr_entry = tk.StringVar()
        self.write_data_entry = tk.StringVar()
        self.read_addr_entry = tk.StringVar()
        self.config_entry = tk.StringVar(value="0" * 20)


        # Variabili per gli input di configurazione iniezione
        self.inj_bypass = tk.IntVar(value=0)
        self.inj_period = tk.IntVar(value=63)
        self.inj_burst = tk.IntVar(value=1)
        self.inj_duty = tk.IntVar(value=8)
        
        # NUOVE VARIABILI PER LO SWEEP DELLA TENSIONE
        self.sweep_start_v = tk.IntVar(value=515)   # Tensione di partenza in mV
        self.sweep_end_v = tk.IntVar(value=495)     # Tensione di fine in mV
        self.sweep_step_v = tk.IntVar(value=1)      # Step di tensione in mV
        self.num_injections = tk.IntVar(value=10)    # Numero di iniezioni per step
        
        # Variabili per l'iniezione su singolo pixel (dalla richiesta precedente)
        self.inj_pixel_x = tk.IntVar(value=0) # Pixel X coordinate (0-31)
        self.inj_pixel_y = tk.IntVar(value=0) # Pixel Y coordinate (0-7)

        # 3. CREAZIONE DELL'INTERFACCIA UTENTE
        self._create_widgets()


    # --- METODI DI CONNESSIONE E COMUNICAZIONE ---
    # ... (Non modificati) ...

    def _get_serial_interface(self) -> SerialInterface:
        """Helper per ottenere un'istanza di SerialInterface con i dati GUI."""
        try:
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())
            return SerialInterface(port, baud, use_serial=USE_SERIAL)
        except ValueError:
            raise ValueError("Baudrate must be an integer.")

    def _send_write(self):
        try:
            addr = int(self.write_addr_entry.get(), 16)
            data = int(self.write_data_entry.get(), 16)
            
            with self._get_serial_interface() as ser_int:
                response = ser_int.write_register(addr, data)
                self.result_var.set(" ".join(f"{b:02X}" for b in response))
                
        except Exception as e:
            messagebox.showerror("Error", f"Write command error: {e}")

    def _send_read(self):
        try:
            addr = int(self.read_addr_entry.get(), 16)
            
            with self._get_serial_interface() as ser_int:
                response = ser_int.read_register(addr)
                self.result_var.set(" ".join(f"{b:02X}" for b in response))
                
        except Exception as e:
            messagebox.showerror("Error", f"Read command error: {e}")

    
    # --- METODI DI LAVORO CON POWER SUPPLY ---
    def _connect_power_supply(self, channel: int = 1):
        """Connette al Power Supply usando PowerSupplyService."""
        try:
            self.ps_service.connect(resource_index=0)
            self.ps_service.set_channel_current(channel, 0.1)
            
            print("Success", "Connected to Power Supply successfully.")
        except Exception as e:
            messagebox.showerror("Error", f"Connection error: {e}")

    
    # --- METODI DI CONFIGURAZIONE FPGA ---

    def _send_spi_word(self, ser_int: SerialInterface, word_value: int):
        """Funzione helper per inviare una singola parola di configurazione SPI usando SerialInterface."""
        
        # L'inizializzazione SPI avviene solo al primo accesso (gestita dal flag)
        if not self.spi_initialized:
            print("First access to SPI, performing initialization")
            # 1) SPI Init: Write 0x8 to 0x30014
            ser_int.write_register(0x30014, 0x8)
            # 2) SPI Init: Write 0x1 to 0x30018
            ser_int.write_register(0x30018, 0x1)
            self.spi_initialized = True
            print("SPI initialization complete")

        # 3) SPI CTRL Clear: Write 0x2214 to 0x30010
        ser_int.write_register(0x30010, 0x2214) 
        # 4) SPI Data: Write config_value to 0x30000
        ser_int.write_register(0x30000, word_value) 
        print(f"SPI 20-bit Data Write: {word_value:020b} (0x{word_value:05X})")

        # 5) SPI CTRL Set: Write 0x2314 to 0x30010
        ser_int.write_register(0x30010, 0x2314) 
        # 7) SPI Read: Read from 0x30000 (per verifica/risposta)
        response = ser_int.read_register(0x30000)
        #print(f"Response: {response:020b}")
        return response


    def _send_configuration(self):
        """Invia una configurazione a 20 bit all'FPGA."""
        try:
            config_str = self.config_entry.get().strip()
            if len(config_str) != 20 or any(c not in '01' for c in config_str):
                messagebox.showerror("Error", "Configuration must be a 20-bit binary string")
                return

            config_value = int(config_str, 2)

            with self._get_serial_interface() as ser_int:
                print(f"SPI 20-bit Data Write: 0x{config_value:05X}")
                # Logica di SPI Init, Clear, Data, Set
                self._send_spi_word(ser_int, config_value)
                print(f"Configuration sent: {config_str}")
                
                # Leggi la risposta finale per l'UI
                response = ser_int.read_register(0x30000)
                self.result_var.set(" ".join(f"{b:02X}" for b in response))

        except Exception as e:
            messagebox.showerror("Error", f"Configuration error: {e}")

    def _send_injection_settings(self):
        """Genera e invia le due parole di configurazione per l'iniezione."""
        try:
            # 1. Genera le parole di configurazione usando AsicConfigurator
            word1, word2 = self.asic_config.get_injection_settings(
                bypass_1b=self.inj_bypass.get(), period_8b=self.inj_period.get(),
                burst_8b=self.inj_burst.get(), duty_4b=self.inj_duty.get()
            )

            with self._get_serial_interface() as ser_int:
                # 2. Invia la prima parola (SPI WRITE INJ1)
                #print(f"Sending INJ1 word: {word1:020b}")
                self._send_spi_word(ser_int, word1)
                
                # 3. Invia la seconda parola (SPI WRITE INJ2)
                #print(f"Sending INJ2 word: {word2:020b}")
                self._send_spi_word(ser_int, word2)
            
            #messagebox.showinfo("Success", "Injection settings sent (Word 1 & 2)")

        except ValueError as e:
            messagebox.showerror("Error", f"Injection value error: {e}")
        except Exception as e:
            messagebox.showerror("Error", f"Communication error: {e}")

    # --- INIEZIONE PIXEL MODIFICATA: ORA RESTITUISCE I DATI ---
    def _inject_a_pixel(self, x: int=0, y: int=0) -> Tuple[float, float]:
        """Genera e invia le impostazioni di configurazione e iniezione per il pixel (x,y).
           Richiede e restituisce i valori ToT e ToA elaborati.
           
           Ritorna:
               Tuple[float, float]: I valori elaborati di (ToT, ToA).
        """
        # Genera le parole da inviare
        pad_word = self.asic_config.get_init_pad_string()
        pointer_word = self.asic_config.get_pixel_pointer_selection(x_5b=x,y_3b=y)
        config_pixel_word = self.asic_config.get_config_pointed_pixel(
            cap25_1b=0, dac_th_5b=0, test_en_1b=1, cap50_1b=0,
            cap_csa_load_1b=0, t_up_1b=0, out_en_1b=1
            )
        inj_word1, inj_word2 = self.asic_config.get_injection_settings(
            bypass_1b=self.inj_bypass.get(), period_8b=self.inj_period.get(),
            burst_8b=self.inj_burst.get(), duty_4b=self.inj_duty.get(), start_1b=1
            )

        tot_request = self.asic_config.get_save_tot_command()
        toa_request = self.asic_config.get_save_toa_command()

        # Invia le parole usando _send_spi_word
        try:
            with self._get_serial_interface() as ser_int:
                print(f"Sending configuration for pixel ({x}, {y})")
                
                # Sequenza di configurazione
                self._send_spi_word(ser_int, pad_word)
                self._send_spi_word(ser_int, pointer_word)
                self._send_spi_word(ser_int, config_pixel_word)
                
                # Sequenza di iniezione
                self._send_spi_word(ser_int, inj_word2)
                self._send_spi_word(ser_int, inj_word1)

                # Richiesta ToT e ToA
                print("Asking for ToT and ToA:")
                tot_response_raw = self._send_spi_word(ser_int, tot_request)
                toa_response_raw = self._send_spi_word(ser_int, toa_request)

                # Elabora e restituisce i risultati
                tot_value = self.asic_config.elaborate_received_tot(tot_response_raw)
                toa_value = self.asic_config.elaborate_received_toa(toa_response_raw)
                
                return tot_value, toa_value

        except Exception as e:
            # Rilancia l'errore per essere gestito dal metodo chiamante
            raise Exception(f"Error during pixel injection configuration/readout: {e}")
        
    # --- SWEEP MODIFICATO: CATTURA DIRETTAMENTE I DATI RESTITUITI ---
    def _sweep_pixel_injection(self):
        """Esegue una scansione delle iniezioni su un pixel specifico variando la tensione di soglia,
           usando i valori della GUI. Calcola le statistiche e salva su file."""
        try:
            # 0. Inizializzazione file di esportazione
            self.exporter.create_falaphel_file()

            # 1. Recupera i valori dalla GUI
            start_voltage = self.sweep_start_v.get()
            end_voltage = self.sweep_end_v.get()
            step = self.sweep_step_v.get()
            num_injections = self.num_injections.get()
            pixel_x = self.inj_pixel_x.get()
            pixel_y = self.inj_pixel_y.get()

            if step <= 0:
                raise ValueError("Lo step di tensione deve essere un numero intero positivo.")

            # 2. Connessione al power supply e preparazione strumento
            self._connect_power_supply()

            # Canale 2 del power supply fisso a 0V 
            self.ps_service.set_channel_voltage(channel=2, voltage=0.0)
            self.ps_service.output_on(channel=2)

            # Genera la lista di tensioni
            sweep_step = -step if start_voltage > end_voltage else step
            stop_value = end_voltage - 1 if start_voltage > end_voltage else end_voltage + 1
            voltages = list(range(start_voltage, stop_value, sweep_step))

            print(f"Starting sweep injection for pixel X={pixel_x}, Y={pixel_y} ({len(voltages)} steps).")

            # 3. Esecuzione dello sweep
            for voltage in voltages:
                tot_results = []
                toa_results = []

                #self.ps_service.output_off(channel=1)
                print(f"--- Setting Vth to {voltage} mV ---")
                self.ps_service.set_channel_voltage(channel=1, voltage=voltage/1000.0)
                self.ps_service.output_on(channel=1)

                # Attendi un breve periodo per la stabilizzazione
                time.sleep(1)

                # Esegue N iniezioni per la tensione corrente
                for i in range(num_injections):
                    print(f"   -> Injection {i+1} of {num_injections}")

                    # CHIAVE: Cattura i risultati direttamente dal ritorno della funzione
                    tot_value, toa_value = self._inject_a_pixel(x=pixel_x, y=pixel_y)

                    # Salva i risultati della singola iniezione
                    tot_results.append(tot_value)
                    toa_results.append(toa_value) # CORRETTO: usa toa_value
                                                  # Nota: nel tuo codice avevi un errore di battitura 'tao_value'
                    print(str(tot_results))
                    time.sleep(1) # Breve pausa tra le iniezioni

                # 4. Calcolo delle statistiche (dopo tutte le N iniezioni)
                if not tot_results:
                    raise RuntimeError(f"Nessun dato ToT/ToA raccolto a {voltage} mV.")

               # Filtra i risultati validi (non NaN)
                valid_tot_results = [r for r in tot_results if not math.isnan(r)]
                valid_toa_results = [r for r in toa_results if not math.isnan(r)]

                print(valid_tot_results)

                if not valid_tot_results:
                    # Gestisce il caso in cui tutti i dati sono NaN
                    avg_tot, std_tot = float('nan'), float('nan')
                    print(f"AVVISO: Nessun dato ToT valido raccolto a {voltage} mV.")
                else:
                    # Calcola media e deviazione standard solo sui dati validi
                    avg_tot = statistics.mean(valid_tot_results)
                    # La deviazione standard necessita di almeno 2 punti; altrimenti usa 0.0 o NaN
                    std_tot = statistics.stdev(valid_tot_results) if len(valid_tot_results) > 1 else 0.0

                if not valid_toa_results:
                    avg_toa, std_toa = float('nan'), float('nan')
                    print(f"AVVISO: Nessun dato ToA valido raccolto a {voltage} mV.")
                else:        

                    avg_toa = statistics.mean(valid_toa_results)
                    std_toa = statistics.stdev(valid_toa_results) if len(valid_toa_results) > 1 else 0.0

                # Calcola l'efficienza: numero di hit / numero totale di iniezioni
                # Un hit è conteggiato quando ToT > 0
                num_hits = sum(1 for tot in tot_results if tot > 0)
                efficiency_val = num_hits / num_injections if num_injections > 0 else 0.0
                
                # 5. Scrittura della riga sul file (una sola riga per tensione)
                self.exporter.write_falaphel_data_row(
                    voltage=voltage,
                    tot_avg=avg_tot,
                    tot_std=std_tot,
                    toa_avg=avg_toa,
                    toa_std=std_toa,
                    efficiency=efficiency_val 
                )

                print(f"Completed {num_injections} injections at {voltage} mV. AVG_ToT={avg_tot:.2f}\n")

            messagebox.showinfo("Success", "Pixel injection sweep completed successfully. Data saved to file.")
            print("Pixel injection sweep completed.")

        except ValueError as e:
            messagebox.showerror("Input Error", f"Error in input values: {e}")
        except Exception as e:
            messagebox.showerror("Error", f"Error during pixel injection sweep: {e}")
        finally:
            # Assicurati che l'alimentazione sia spenta alla fine, anche in caso di errore
            try:
                self.ps_service.output_off(channel=1)
                print("Power Supply turned off.")
            except Exception as e:
                print(f"Warning: Could not turn off Power Supply: {e}")

    # --- WIDGET E LAYOUT ---
    def _create_widgets(self):
        """Costruisce tutti i widget della GUI."""
        # Sezione 0: Connessione
        frame_conn = ttk.LabelFrame(self.master, text="Connection Settings")
        frame_conn.grid(row=0, column=0, columnspan=2, padx=10, pady=5, sticky="ew")

        tk.Label(frame_conn, text="Port:").grid(row=0, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_conn, textvariable=self.port_entry).grid(row=0, column=1, padx=5, pady=2, sticky="ew")

        tk.Label(frame_conn, text="Baudrate:").grid(row=1, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_conn, textvariable=self.baud_entry).grid(row=1, column=1, padx=5, pady=2, sticky="ew")
        
        # Sezione 1: Single Commands
        frame_single = ttk.LabelFrame(self.master, text="Single Commands Section")
        frame_single.grid(row=1, column=0, columnspan=2, padx=10, pady=10, sticky="ew")
        
        # Write
        tk.Label(frame_single, text="Write Addr (hex):").grid(row=0, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.write_addr_entry).grid(row=0, column=1, padx=5, pady=2, sticky="ew")
        tk.Label(frame_single, text="Write Data (hex):").grid(row=1, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.write_data_entry).grid(row=1, column=1, padx=5, pady=2, sticky="ew")
        tk.Button(frame_single, text="Send Write", command=self._send_write).grid(row=2, column=0, columnspan=2, pady=5)
        
        # Read
        tk.Label(frame_single, text="Read Addr (hex):").grid(row=3, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.read_addr_entry).grid(row=3, column=1, padx=5, pady=2, sticky="ew")
        tk.Button(frame_single, text="Send Read", command=self._send_read).grid(row=4, column=0, columnspan=2, pady=5)
        
        # Result
        tk.Label(frame_single, text="Read Result:").grid(row=5, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.result_var, state='readonly').grid(row=5, column=1, padx=5, pady=2, sticky="ew")
        
        # Sezione 2: Raw Configuration
        frame_raw_config = ttk.LabelFrame(self.master, text="Send Raw Calibration String")
        frame_raw_config.grid(row=2, column=0, columnspan=2, padx=10, pady=10, sticky="ew")

        tk.Label(frame_raw_config, text="Config (20 bit binary):").grid(row=0, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_raw_config, textvariable=self.config_entry).grid(row=0, column=1, padx=5, pady=2, sticky="ew")
        tk.Button(frame_raw_config, text="Send Configuration", command=self._send_configuration).grid(row=1, column=0, columnspan=2, pady=5)

        # Sezione 3: Injection Settings (Utilizzo di AsicConfigurator)
        frame_inj = ttk.LabelFrame(self.master, text="Calibration/Injection Settings (AsicConfigurator)")
        frame_inj.grid(row=3, column=0, columnspan=2, padx=10, pady=10, sticky="ew")

        # Configurazione Tensione/Sweep
        tk.Label(frame_inj, text="Start Vth (mV):").grid(row=0, column=0, padx=5, sticky="w")
        tk.Entry(frame_inj, textvariable=self.sweep_start_v).grid(row=0, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="End Vth (mV):").grid(row=1, column=0, padx=5, sticky="w")
        tk.Entry(frame_inj, textvariable=self.sweep_end_v).grid(row=1, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="Step (mV):").grid(row=2, column=0, padx=5, sticky="w")
        tk.Entry(frame_inj, textvariable=self.sweep_step_v).grid(row=2, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="# Injections per Step:").grid(row=3, column=0, padx=5, sticky="w")
        tk.Entry(frame_inj, textvariable=self.num_injections).grid(row=3, column=1, padx=5, sticky="ew")

        # Bottone di avvio
        tk.Button(frame_inj, text="Start Injection Sweep", command=self._sweep_pixel_injection).grid(row=5, column=0, columnspan=4, pady=10)


# ==============================================================================
# MAIN
# ==============================================================================

def signal_handler(sig, frame):
    psService = PowerSupplyService()
    psService.output_off(channel=1)
    print("Ctrl+C pressed. Exiting gracefully.")
    # other cleanup/exit code

    sys.exit(0)

# register the custom signal handler for Ctrl+C
signal.signal(signal.SIGINT, signal_handler)


if __name__ == "__main__":
    root = tk.Tk()
    app = FpgaControlApp(root)
    root.mainloop()