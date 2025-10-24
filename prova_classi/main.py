import serial
import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import csv
from typing import Tuple
# Importa AsicConfigurator (assumendo sia nel file asic_config.py)
from asic_config import AsicConfigurator
from serial_interface import SerialInterface 




USE_SERIAL = False # True per usare la porta reale, False per emulare


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

        # 2. VARIABILI DI CONTROLLO TKINTER (omesse per brevità, sono corrette)
        self.result_var = tk.StringVar()
        self.port_entry = tk.StringVar(value="COM3")
        self.baud_entry = tk.StringVar(value="115200")
        self.write_addr_entry = tk.StringVar()
        self.write_data_entry = tk.StringVar()
        self.read_addr_entry = tk.StringVar()
        self.config_entry = tk.StringVar(value="0" * 20)

        # Variabili per la configurazione dei PAD
        

        # Variabili per i nuovi input di configurazione iniezione
        self.inj_bypass = tk.IntVar(value=0)
        self.inj_period = tk.IntVar(value=63)
        self.inj_burst = tk.IntVar(value=1)
        self.inj_duty = tk.IntVar(value=8)

        # 3. CREAZIONE DELL'INTERFACCIA UTENTE
        self._create_widgets()

    # --- METODI DI CONNESSIONE E COMUNICAZIONE AGGIORNATI ---
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

    def _process_csv_file(self):
        """Gestisce la selezione e l'invio dei dati del file CSV."""
        filepath = filedialog.askopenfilename(defaultextension=".csv", filetypes=[("CSV files", "*.csv")])
        if not filepath:
            return

        try:
            with self._get_serial_interface() as ser_int:
                with open(filepath, newline='') as csvfile:
                    reader = csv.reader(csvfile)
                    for address, row in enumerate(reader):
                        if not row or not row[0].strip():
                            continue
                        try:
                            # Assumiamo che la prima colonna contenga il dato esadecimale
                            data = int(row[0].strip(), 16) 
                            # L'indirizzo è l'indice della riga, come nel codice originale
                            ser_int.write_register(address, data) 
                        except ValueError:
                            print(f"Invalid data at row {address}: {row[0]}")
            
            #messagebox.showinfo("Success", f"CSV file '{filepath.split('/')[-1]}' processed successfully.")

        except Exception as e:
            messagebox.showerror("Error", f"Error processing CSV: {e}")


    # --- METODI DI CONFIGURAZIONE FPGA AGGIORNATI ---

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
        ser_int.read_register(0x30000)


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

    def _inject_a_pixel(self):
        """Genera e invia le impostazioni dei pad, set puntatore al pixel 0,0, invia configurazione di lavoro al pixel puntato e impostazioni e di iniezione basate sui valori GUI."""

        # Genera le parole da inviare
        pad_word = self.asic_config.get_init_pad_string() # Usa i valori di default per ora
        pointer_word = self.asic_config.get_pixel_pointer_selection(x_5b=0,y_3b=0) # Selezione Pixel (0,0)
        config_pixel_word = self.asic_config.get_config_pointed_pixel(
            cap25_1b=0,
            dac_th_5b=0,
            test_en_1b=1,
            cap50_1b=0,
            cap_csa_load_1b=0,
            t_up_1b=0,
            out_en_1b=1
            ) # Configurazione Pixel Puntato
        inj_word1, inj_word2 = self.asic_config.get_injection_settings(
                bypass_1b=self.inj_bypass.get(), period_8b=self.inj_period.get(),
                burst_8b=self.inj_burst.get(), duty_4b=self.inj_duty.get()
            ) # Impostazioni Iniezione
        

        # Invia le parole usando _send_spi_word
        try:
            with self._get_serial_interface() as ser_int:
                print("Sending PAD Initialization Word:")
                self._send_spi_word(ser_int, pad_word)

                print("Sending Pixel Pointer Selection Word:")
                self._send_spi_word(ser_int, pointer_word)  

                print("Sending Config Pointed Pixel Word:")
                self._send_spi_word(ser_int, config_pixel_word)
                
                print("Sending Injection Settings Word 2:") #invio prima la 2 perchè la 1 contiene il comando di start
                self._send_spi_word(ser_int, inj_word2)

                print("Sending Injection Settings Word 1:")
                self._send_spi_word(ser_int, inj_word1)

               

            #messagebox.showinfo("Success", "Pixel injection configuration sent successfully.")

        except Exception as e:
            messagebox.showerror("Error", f"Error during pixel injection configuration: {e}")
       
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
        frame_inj = ttk.LabelFrame(self.master, text="Set Injection Section (AsicConfigurator)")
        frame_inj.grid(row=3, column=0, columnspan=2, padx=10, pady=10, sticky="ew")

        # Input per i parametri di Injection (omessi per brevità, sono corretti)
        tk.Label(frame_inj, text="Bypass (0/1):").grid(row=0, column=0, padx=5, sticky="w")
        tk.Entry(frame_inj, textvariable=self.inj_bypass).grid(row=0, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="Period (0-63):").grid(row=1, column=0, padx=5, sticky="w")
        tk.Entry(frame_inj, textvariable=self.inj_period).grid(row=1, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="Burst (0-63):").grid(row=2, column=0, padx=5, sticky="w")
        tk.Entry(frame_inj, textvariable=self.inj_burst).grid(row=2, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="Duty (0-15):").grid(row=3, column=0, padx=5, sticky="w")
        tk.Entry(frame_inj, textvariable=self.inj_duty).grid(row=3, column=1, padx=5, sticky="ew")

        tk.Button(frame_inj, text="Generate and Inject", command=self._inject_a_pixel).grid(row=4, column=0, columnspan=2, pady=10)
        
        # Sezione 4: CSV File - per ora non serve
        #frame_csv = ttk.LabelFrame(self.master, text="Process CSV File")
        #frame_csv.grid(row=4, column=0, columnspan=2, padx=10, pady=10, sticky="ew")
        #tk.Button(frame_csv, text="Load & Send CSV", command=self._process_csv_file).grid(row=0, column=0, columnspan=2, pady=10)


# ==============================================================================
# MAIN
# ==============================================================================
if __name__ == "__main__":
    root = tk.Tk()
    app = FpgaControlApp(root)
    root.mainloop()