import sys
import tkinter as tk
from tkinter import messagebox, ttk
from asic_config import AsicConfigurator
from serial_interface import SerialInterface 
from export_service import ExportService
from fpga_measurement_engine import FpgaMeasurementEngine
import signal

# ============================================================================== 
# CONFIGURAZIONE GLOBALE (Mantienila in alto per una facile modifica)
# ============================================================================== 
USE_SERIAL = True # True per usare la porta reale, False per emulare

if USE_SERIAL:
    # Assicurati che PowerSupplyService sia importato solo se necessario per evitare errori di import
    from power_supply_controller import PowerSupplyService 
    PowerSupplyService = PowerSupplyService # Riassegna per l'uso nella classe Logica

# ============================================================================== 
# CLASSE PRINCIPALE DELL'APPLICAZIONE (GUI)
# ============================================================================== 
class FpgaControlApp:
    def __init__(self, master):
        self.master = master
        master.title("FPGA Control GUI (Refactored)")

        # 1. INIZIALIZZAZIONE DELLE DIPENDENZE ESTERNE
        self.asic_config = AsicConfigurator()
        self.exporter = ExportService()
        
        # Power Supply Service (solo se non si usa l'emulazione)
        ps_service = PowerSupplyService() if USE_SERIAL else None


        
        # FUNZIONE FACTORY per creare l'interfaccia seriale
        def serial_interface_factory(port: str, baud: int, use_serial: bool):
             # Il costruttore SerialInterface deve essere in grado di gestire l'emulazione
            return SerialInterface(port, baud, use_serial=use_serial)

        # 2. INIEZIONE DELLE DIPENDENZE NELL'ENGINE
        self.engine = FpgaMeasurementEngine(
            serial_interface_factory=serial_interface_factory,
            asic_config=self.asic_config,
            exporter=self.exporter,
            ps_service=ps_service
        )
                    # 2. Connessione e preparazione power supply
        self.engine.connect_power_supply() # Usa l'iniezione per connettersi
        self.engine._prepare_power_supply_for_sweep() 
        # 3. VARIABILI DI CONTROLLO TKINTER
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
        self.sweep_start_v = tk.IntVar(value=80)   # Tensione di partenza in mV
        self.sweep_end_v = tk.IntVar(value=10)     # Tensione di fine in mV
        self.sweep_step_v = tk.IntVar(value=5)     # Step di tensione in mV
        self.num_injections = tk.IntVar(value=10) # Numero di iniezioni per step

        # Variabili per l'iniezione su singolo pixel
        self.inj_pixel_x = tk.IntVar(value=6)
        self.inj_pixel_y = tk.IntVar(value=6)

        # VARIABILI PER LA CONFIGURAZIONE DEL PIXEL
        self.config_cap50 = tk.IntVar(value=1)
        self.config_cap25 = tk.IntVar(value=0)
        self.config_cap_csa_load = tk.IntVar(value=1)
        self.config_dac_th = tk.IntVar(value=0)
        self.config_test_en = tk.IntVar(value=1)
        self.config_t_up = tk.IntVar(value=0)
        self.config_out_en = tk.IntVar(value=1)

        # VARIABILI PER LA SOTTOMATRICE SCAN
        self.sub_matrix_start_x = tk.IntVar(value=3) # Vertice in alto a sinistra X
        self.sub_matrix_start_y = tk.IntVar(value=3) # Vertice in alto a sinistra Y
        self.sub_matrix_width = tk.IntVar(value=10)  # Larghezza (colonne)
        self.sub_matrix_height = tk.IntVar(value=4) # Altezza (righe)

        # 4. CREAZIONE DELL'INTERFACCIA UTENTE
        self._create_widgets()

    # --- METODI DELLA GUI (Delegazione all'Engine) ---
    
    def _send_write_gui(self):
        """Prende i dati dalla GUI e chiama l'Engine."""
        try:
            addr = int(self.write_addr_entry.get(), 16)
            data = int(self.write_data_entry.get(), 16)
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())
            
            response = self.engine.send_write_command(port, baud, addr, data)
            self.result_var.set(response)
        except Exception as e:
            messagebox.showerror("Error", f"Write command error: {e}")

    def _send_read_gui(self):
        """Prende i dati dalla GUI e chiama l'Engine."""
        try:
            addr = int(self.read_addr_entry.get(), 16)
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())
            
            response = self.engine.send_read_command(port, baud, addr)
            self.result_var.set(response)
        except Exception as e:
            messagebox.showerror("Error", f"Read command error: {e}")
            
    def _send_configuration(self):
        """Invia una configurazione a 20 bit. Logica nell'Engine."""
        try:
            config_str = self.config_entry.get().strip()
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())
            
            response = self.engine.send_full_configuration(port, baud, config_str)
            self.result_var.set(response)
            messagebox.showinfo("Success", f"Configuration sent: {config_str}")
        except ValueError as e:
            messagebox.showerror("Input Error", f"Configuration value error: {e}")
        except Exception as e:
            messagebox.showerror("Error", f"Configuration error: {e}")

    def inject_single_pixel_4button(self):
        """Prepara i parametri e chiama l'iniezione sull'Engine."""
        try:
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())
            
            pad_word = self.asic_config.get_init_pad_string()
            pointer_word = self.asic_config.get_pixel_pointer_selection(x_5b=self.inj_pixel_x.get(), y_3b=self.inj_pixel_y.get())

            config_pixel_word = self.asic_config.get_config_pointed_pixel(
                cap25_1b=self.config_cap25.get(), dac_th_5b=self.config_dac_th.get(), test_en_1b=self.config_test_en.get(), 
                cap50_1b=self.config_cap50.get(), cap_csa_load_1b=self.config_cap_csa_load.get(), 
                t_up_1b=self.config_t_up.get(), out_en_1b=self.config_out_en.get()
            )

            inj_word1_start, inj_word2_start = self.asic_config.get_injection_settings(
                bypass_1b=self.inj_bypass.get(), period_8b=self.inj_period.get(), burst_8b=self.inj_burst.get(), duty_4b=self.inj_duty.get(), start_1b=1
            )
            inj_word1_stop, inj_word2_stop = self.asic_config.get_injection_settings(
                bypass_1b=self.inj_bypass.get(), period_8b=self.inj_period.get(), burst_8b=self.inj_burst.get(), duty_4b=self.inj_duty.get(), start_1b=0
            )
            tot_request = self.asic_config.get_save_tot_command()
            toa_request = self.asic_config.get_save_toa_command()

            binary_command_params = {
                'pad_word': pad_word,
                'pointer_word': pointer_word,
                'config_pixel_word': config_pixel_word,
                'inj_word1_start': inj_word1_start,
                'inj_word2_start': inj_word2_start,
                'inj_word1_stop': inj_word1_stop,
                'inj_word2_stop': inj_word2_stop,
                'tot_request': tot_request,
                'toa_request': toa_request
            }
            
            # Delega all'Engine (l'Engine chiamerà _inject_a_pixel con apertura/chiusura locale)
            tot_value, toa_value = self.engine.inject_single_pixel(
                port, baud, self.inj_pixel_x.get(), self.inj_pixel_y.get(), 
                binary_command_params
            )
            #messagebox.showinfo("Injection Result", f"Pixel ({self.inj_pixel_x.get()},{self.inj_pixel_y.get()}) injected.\nToT={tot_value:.2f}, ToA={toa_value:.2f}")

        except Exception as e:
            messagebox.showerror("Error", f"Pixel injection error: {e}")

 
        
        
    def _sweep_pixel_injection_opt(self):
        """Prepara i parametri dello sweep e delega all'Engine."""
        try:
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())

            # 1. Genera le parole da inviare
            pad_word = self.asic_config.get_init_pad_string()
            pointer_word = self.asic_config.get_pixel_pointer_selection(x_5b=self.inj_pixel_x.get(), y_3b=self.inj_pixel_y.get())

            config_pixel_word = self.asic_config.get_config_pointed_pixel(
                cap25_1b=self.config_cap25.get(), dac_th_5b=self.config_dac_th.get(), test_en_1b=self.config_test_en.get(), 
                cap50_1b=self.config_cap50.get(), cap_csa_load_1b=self.config_cap_csa_load.get(), 
                t_up_1b=self.config_t_up.get(), out_en_1b=self.config_out_en.get()
            )

            inj_word1_start, inj_word2_start = self.asic_config.get_injection_settings(
                bypass_1b=self.inj_bypass.get(), period_8b=self.inj_period.get(), burst_8b=self.inj_burst.get(), duty_4b=self.inj_duty.get(), start_1b=1
            )
            inj_word1_stop, inj_word2_stop = self.asic_config.get_injection_settings(
                bypass_1b=self.inj_bypass.get(), period_8b=self.inj_period.get(), burst_8b=self.inj_burst.get(), duty_4b=self.inj_duty.get(), start_1b=0
            )
            tot_request = self.asic_config.get_save_tot_command()
            toa_request = self.asic_config.get_save_toa_command()

            sweep_params = {
                'start_v': self.sweep_start_v.get(), 'end_v': self.sweep_end_v.get(), 
                'step_v': self.sweep_step_v.get(), 'num_injections': self.num_injections.get(),
                'pixel_x': self.inj_pixel_x.get(), 'pixel_y': self.inj_pixel_y.get()
            }

            pixel_config_params = {
                'cap25': self.config_cap25.get(), 'dac_th': self.config_dac_th.get(), 
                'test_en': self.config_test_en.get(), 'cap50': self.config_cap50.get(),
                'cap_csa_load': self.config_cap_csa_load.get(), 't_up': self.config_t_up.get(), 
                'out_en': self.config_out_en.get(), 'x': self.inj_pixel_x.get(), 'y': self.inj_pixel_y.get()
            }

            binary_command_params = {
                'pad_word': pad_word,
                'pointer_word': pointer_word,
                'config_pixel_word': config_pixel_word,
                'inj_word1_start': inj_word1_start,
                'inj_word2_start': inj_word2_start,
                'inj_word1_stop': inj_word1_stop,
                'inj_word2_stop': inj_word2_stop,
                'tot_request': tot_request,
                'toa_request': toa_request
            }

            # Delega l'intera operazione di sweep all'Engine
            elapsed_time = self.engine.perform_sweep(port, baud, sweep_params, binary_command_params, pixel_config_params, isMatrixScan=False)
            
            messagebox.showinfo("Success", f"Pixel injection sweep completed successfully in {elapsed_time:.2f} seconds. Data saved to file.")

        except ValueError as e:
            messagebox.showerror("Input Error", f"Error in input values: {e}")
        except RuntimeError as e:
            messagebox.showerror("Service Error", f"{e}")
        except Exception as e:
            messagebox.showerror("Error", f"Error during pixel injection sweep: {e}")

    def _scan_matrix_injection(self):
        """Scansiona tutta la matrice dei pixel e inietta su ciascuno."""
        try:
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())

            scan_params= {
                'start_v': self.sweep_start_v.get(), 'end_v': self.sweep_end_v.get(), 
                'step_v': self.sweep_step_v.get(), 'num_injections': self.num_injections.get(),
                'pixel_x': self.inj_pixel_x.get(), 'pixel_y': self.inj_pixel_y.get()
            }
            pixel_config_params = {
                'cap25': self.config_cap25.get(), 'dac_th': self.config_dac_th.get(), 
                'test_en': self.config_test_en.get(), 'cap50': self.config_cap50.get(),
                'cap_csa_load': self.config_cap_csa_load.get(), 't_up': self.config_t_up.get(), 
                'out_en': self.config_out_en.get()
            }
            
            injection_timing_settings = {
                'bypass': self.inj_bypass.get(), 'period': self.inj_period.get(),
                'burst': self.inj_burst.get(), 'duty': self.inj_duty.get()
            }


            # Delega l'intera operazione di scansione all'Engine
            total_pixels, successful_pixels, failed_pixels, total_time, avg_time_per_pixel = self.engine.perform_matrix_scan(
                port=port,
                baud=baud,
                sweep_params=scan_params,
                timing_injection_settings=injection_timing_settings,
                pixel_config_params=pixel_config_params
                )
            
            messagebox.showinfo("Success", f"Matrix injection scan completed successfully in {total_time} seconds. Data saved to file.")

        except ValueError as e:
            messagebox.showerror("Input Error", f"Error in input values: {e}")
        except RuntimeError as e:
            messagebox.showerror("Service Error", f"{e}")
        except Exception as e:
            messagebox.showerror("Error", f"Error during matrix injection scan: {e}")


    def _scan_sub_matrix_injection(self):
        """Prepara i parametri della sotto-matrice e delega all'Engine."""
        try:
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())
            
            # Parametri della Sotto-Matrice
            start_x = self.sub_matrix_start_x.get()
            start_y = self.sub_matrix_start_y.get()
            width = self.sub_matrix_width.get()
            height = self.sub_matrix_height.get()

            # Parametri di Sweep (Tensione)
            sweep_params= {
                'start_v': self.sweep_start_v.get(), 'end_v': self.sweep_end_v.get(), 
                'step_v': self.sweep_step_v.get(), 'num_injections': self.num_injections.get(),
                'pixel_x': 0, 'pixel_y': 0 # Questi saranno sovrascritti nell'Engine
            }
            pixel_config_params = {
                'cap25': self.config_cap25.get(), 'dac_th': self.config_dac_th.get(), 
                'test_en': self.config_test_en.get(), 'cap50': self.config_cap50.get(),
                'cap_csa_load': self.config_cap_csa_load.get(), 't_up': self.config_t_up.get(), 
                'out_en': self.config_out_en.get()
            }
            
            injection_timing_settings = {
                'bypass': self.inj_bypass.get(), 'period': self.inj_period.get(),
                'burst': self.inj_burst.get(), 'duty': self.inj_duty.get()
            }


            # CHIAMA IL NUOVO METODO perform_sub_matrix_scan
            total_pixels, successful_pixels, failed_pixels, total_time, avg_time_per_pixel = self.engine.perform_sub_matrix_scan(
                port=port,
                baud=baud,
                sweep_params=sweep_params,
                timing_injection_settings=injection_timing_settings,
                pixel_config_params=pixel_config_params,
                start_x=start_x,
                start_y=start_y,
                width=width,
                height=height
            )
            
            messagebox.showinfo("Success", f"Sub-Matrix scan completed successfully. Size: {width}x{height}. Data saved to file.")

        except ValueError as e:
            messagebox.showerror("Input Error", f"Error in input values: {e}")
        except RuntimeError as e:
            messagebox.showerror("Service Error", f"{e}")
        except Exception as e:
            messagebox.showerror("Error", f"Error during sub-matrix injection scan: {e}")


    def _send_reset_gui(self):
        """Invia il comando di resetn all'FPGA tramite l'Engine."""
        try:
            port = self.port_entry.get()
            baud = int(self.baud_entry.get())
            
            self.engine._send_resetn(port, baud)
          
            print("RESETn command sent to FPGA.")
        except Exception as e:
            messagebox.showerror("Error", f"Resetn command error: {e}")

    # --- WIDGET E LAYOUT ---
    def _create_widgets(self):
        """Costruisce tutti i widget della GUI (Identico al codice originale, aggiornati solo i comandi)."""
        # --- Sezione Connessione ---
        frame_conn = ttk.LabelFrame(self.master, text="Connection Settings", borderwidth=3, relief="solid")
        frame_conn.grid(row=0, column=0, columnspan=2, padx=10, pady=5, sticky="ew")
        tk.Label(frame_conn, text="Port:").grid(row=0, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_conn, textvariable=self.port_entry).grid(row=0, column=1, padx=5, pady=2, sticky="ew")
        tk.Label(frame_conn, text="Baudrate:").grid(row=1, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_conn, textvariable=self.baud_entry).grid(row=1, column=1, padx=5, pady=2, sticky="ew")

        # --- Bottone RESETN in alto a destra ---
        tk.Button(
            self.master, 
            text="Send Resetn", 
            command=self._send_reset_gui, 
            bg="#ff6666", 
            fg="white", 
            font=("Arial", 10, "bold")
        ).grid(row=0, column=2, padx=10, pady=10, sticky="ew") # Posizione: Riga 0, Colonna 2

        # --- Sezione Comandi Singoli ---
        frame_single = ttk.LabelFrame(self.master, text="Single Commands Section")
        frame_single.grid(row=2, column=0, columnspan=2, padx=10, pady=10, sticky="ew")
        # Read/Write Register (Aggiunti per completezza del refactoring, anche se non erano nel codice iniziale ma impliciti)
        tk.Label(frame_single, text="Write Addr (Hex):").grid(row=0, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.write_addr_entry).grid(row=0, column=1, padx=5, pady=2, sticky="ew")
        tk.Label(frame_single, text="Write Data (Hex):").grid(row=1, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.write_data_entry).grid(row=1, column=1, padx=5, pady=2, sticky="ew")
        tk.Button(frame_single, text="Send Write", command=self._send_write_gui).grid(row=2, column=0, columnspan=2, pady=5)

        tk.Label(frame_single, text="Read Addr (Hex):").grid(row=3, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.read_addr_entry).grid(row=3, column=1, padx=5, pady=2, sticky="ew")
        tk.Button(frame_single, text="Send Read", command=self._send_read_gui).grid(row=4, column=0, columnspan=2, pady=5)
        
        tk.Label(frame_single, text="Read Result:").grid(row=5, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.result_var, state='readonly').grid(row=5, column=1, padx=5, pady=2, sticky="ew")
        
        # Configurazione ASIC
        tk.Label(frame_single, text="Config (20 bit binary):").grid(row=6, column=0, padx=5, pady=2, sticky="w")
        tk.Entry(frame_single, textvariable=self.config_entry).grid(row=6, column=1, padx=5, pady=2, sticky="ew")
        tk.Button(frame_single, text="Send Configuration", command=self._send_configuration).grid(row=7, column=0, columnspan=2, pady=5)


        # --- Sezione Calibrazione/Iniezione ---
        frame_inj = ttk.LabelFrame(self.master, text="Calibration/Injection Settings")
        frame_inj.grid(row=3, column=0, columnspan=2, padx=10, pady=10, sticky="ew")

        frame_pixel_config = ttk.LabelFrame(frame_inj, text="Pixel Configuration")
        frame_pixel_config.grid(row=0, column=0, columnspan=4, padx=5, pady=5, sticky="ew")
        tk.Label(frame_pixel_config, text="Pixel X (0-31):").grid(row=0, column=0, padx=5, sticky="w")
        tk.Spinbox(frame_pixel_config, textvariable=self.inj_pixel_x, from_=0, to=31, width=5).grid(row=0, column=1, padx=5, sticky="ew")
        tk.Label(frame_pixel_config, text="Pixel Y (0-7):").grid(row=0, column=2, padx=5, sticky="w")
        tk.Spinbox(frame_pixel_config, textvariable=self.inj_pixel_y, from_=0, to=7, width=5).grid(row=0, column=3, padx=5, sticky="ew")
        tk.Label(frame_pixel_config, text="DAC_TH (0-31):").grid(row=1, column=0, padx=5, sticky="w")
        tk.Spinbox(frame_pixel_config, textvariable=self.config_dac_th, from_=0, to=31, width=5).grid(row=1, column=1, padx=5, sticky="ew")
        tk.Checkbutton(frame_pixel_config, text="cap50", variable=self.config_cap50).grid(row=2, column=0, padx=5, sticky="w")
        tk.Checkbutton(frame_pixel_config, text="cap25", variable=self.config_cap25).grid(row=2, column=1, padx=5, sticky="w")
        tk.Checkbutton(frame_pixel_config, text="cap_csa_load", variable=self.config_cap_csa_load).grid(row=2, column=2, padx=5, sticky="w")
        tk.Checkbutton(frame_pixel_config, text="test_en", variable=self.config_test_en).grid(row=3, column=0, padx=5, sticky="w")
        tk.Checkbutton(frame_pixel_config, text="t_up", variable=self.config_t_up).grid(row=3, column=1, padx=5, sticky="w")
        tk.Checkbutton(frame_pixel_config, text="out_en", variable=self.config_out_en).grid(row=3, column=2, padx=5, sticky="w")

        tk.Button(frame_inj, text="Inject Single Pixel (X,Y)", command=self.inject_single_pixel_4button, bg="light blue").grid(row=4, column=0, columnspan=4, pady=10)

        tk.Label(frame_inj, text="Start Vth (mV):").grid(row=5, column=0, padx=5, sticky="w")
        tk.Spinbox(frame_inj, textvariable=self.sweep_start_v, from_=0, to=1000, width=10).grid(row=5, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="End Vth (mV):").grid(row=6, column=0, padx=5, sticky="w")
        tk.Spinbox(frame_inj, textvariable=self.sweep_end_v, from_=0, to=1000, width=10).grid(row=6, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="Step (mV):").grid(row=7, column=0, padx=5, sticky="w")
        tk.Spinbox(frame_inj, textvariable=self.sweep_step_v, from_=1, to=100, width=10).grid(row=7, column=1, padx=5, sticky="ew")
        tk.Label(frame_inj, text="# Injections per Step:").grid(row=8, column=0, padx=5, sticky="w")
        tk.Spinbox(frame_inj, textvariable=self.num_injections, from_=1, to=10000, width=10).grid(row=8, column=1, padx=5, sticky="ew")

        tk.Button(frame_inj, text="Start Injection Sweep", command=self._sweep_pixel_injection_opt, bg="light green").grid(row=9, column=0, columnspan=4, pady=10)
        
        # --- Sezione Scansione Matrice ---
        frame_matrix = ttk.LabelFrame(self.master, text="Matrix Scan Settings")
        frame_matrix.grid(row=3, column=2, padx=10, pady=10, sticky="nsew")

        tk.Label(frame_matrix, text="Full Scan (32x8)", font=("Arial", 10, "bold")).grid(row=0, column=0, columnspan=2, pady=5)
        tk.Label(frame_matrix, text="Uses sweep and pixel config", font=("Arial", 8, "italic")).grid(row=1, column=0, columnspan=2, pady=2)
        tk.Label(frame_matrix, text="from left section").grid(row=2, column=0, columnspan=2, pady=2)

        tk.Button(frame_matrix, text="Start Full Matrix Scan", command=self._scan_matrix_injection, bg="orange", font=("Arial", 10, "bold")).grid(row=3, column=0, columnspan=2, pady=10, padx=10, sticky="ew")

        # --- Sotto-sezione Sotto-Matrice ---
        frame_sub_matrix = ttk.LabelFrame(frame_matrix, text="Sub-Matrix Scan")
        frame_sub_matrix.grid(row=4, column=0, columnspan=2, padx=5, pady=10, sticky="ew")

        # Input Vertice (Start X, Start Y)
        tk.Label(frame_sub_matrix, text="Start X (0-31):").grid(row=0, column=0, padx=5, sticky="w")
        tk.Spinbox(frame_sub_matrix, textvariable=self.sub_matrix_start_x, from_=0, to=31, width=5).grid(row=0, column=1, padx=5, sticky="ew")
        tk.Label(frame_sub_matrix, text="Start Y (0-7):").grid(row=1, column=0, padx=5, sticky="w")
        tk.Spinbox(frame_sub_matrix, textvariable=self.sub_matrix_start_y, from_=0, to=7, width=5).grid(row=1, column=1, padx=5, sticky="ew")

        # Input Dimensioni (Width, Height)
        tk.Label(frame_sub_matrix, text="Width (1-32):").grid(row=0, column=2, padx=5, sticky="w")
        tk.Spinbox(frame_sub_matrix, textvariable=self.sub_matrix_width, from_=1, to=32, width=5).grid(row=0, column=3, padx=5, sticky="ew")
        tk.Label(frame_sub_matrix, text="Height (1-8):").grid(row=1, column=2, padx=5, sticky="w")
        tk.Spinbox(frame_sub_matrix, textvariable=self.sub_matrix_height, from_=1, to=8, width=5).grid(row=1, column=3, padx=5, sticky="ew")

        # Bottone Sotto-Matrice Scan
        tk.Button(frame_sub_matrix, text="Start Sub-Matrix Scan", command=self._scan_sub_matrix_injection, bg="gold", font=("Arial", 10, "bold")).grid(row=2, column=0, columnspan=4, pady=10, padx=5, sticky="ew")
# ============================================================================== 
# MAIN
# ============================================================================== 
def signal_handler(sig, frame):
    # La gestione del segnale deve spegnere il power supply
    # Questo richiede che il PowerSupplyService sia disponibile in questo contesto.
    if USE_SERIAL:
        try:
            psService = PowerSupplyService()
            psService.output_off(channel=1)
            print("Ctrl+C pressed. Power Supply channel 1 turned off. Exiting gracefully.")
        except Exception as e:
            print(f"Ctrl+C pressed. Warning: Could not turn off Power Supply: {e}")
    else:
        print("Ctrl+C pressed. Exiting gracefully.")
        
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

if __name__ == "__main__":
    # Assicurati che l'import di PowerSupplyService sia gestito
    if USE_SERIAL and 'PowerSupplyService' not in locals():
         print("FATAL: Per USE_SERIAL=True, assicurarsi che power_supply_controller sia importabile.")
         sys.exit(1)
         
    root = tk.Tk()
    app = FpgaControlApp(root)
    root.mainloop()