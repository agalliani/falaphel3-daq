from typing import Tuple, Optional, Dict, Any, List
from asic_config import AsicConfigurator
from serial_interface import SerialInterface 
from export_service import ExportService
import time
import math
import statistics



# ============================================================================== 
# COSTANTI REGISTRI FPGA/SPI (Spostate fuori dalla GUI)
# ============================================================================== 
REG_SPI_DATA = 0x30000
REG_SPI_CTRL = 0x30010
REG_SPI_INIT_1 = 0x30014
REG_SPI_INIT_2 = 0x30018

VAL_SPI_INIT_1 = 0xF
VAL_SPI_INIT_2 = 0x1
VAL_SPI_CTRL_CLEAR = 0x2214
VAL_SPI_CTRL_SET = 0x2314

# ============================================================================== 
# CLASSE LOGICA: GESTIONE MISURE E I/O (FpgaMeasurementEngine)
# ============================================================================== 
class FpgaMeasurementEngine:
    """
    Gestisce tutte le operazioni di I/O (FPGA/SPI, Seriale, Power Supply)
    e la logica di elaborazione (Configurazione ASIC, Sweep, Export).
    """
    def __init__(self, serial_interface_factory, asic_config: AsicConfigurator, 
                 exporter: ExportService, ps_service: Optional[Any] = None):
        """
        Inietta le dipendenze.
        serial_interface_factory: Callable che ritorna SerialInterface(port, baud, ...)
        """
        self.serial_interface_factory = serial_interface_factory
        self.asic_config = asic_config
        self.exporter = exporter
        self.ps_service = ps_service # Sarà None se USE_SERIAL è True e non è stato iniettato
        self.spi_initialized = False # Flag per l'inizializzazione SPI
        self.injection_delay = 0.001 # Ritardo tra le iniezioni

        # Variabile per tracciare l'ultimo pixel configurato: (x, y)
        self._last_configured_pixel = None

    def _get_serial_interface(self, port: str, baud: int) -> SerialInterface:
        """Helper per ottenere un'istanza di SerialInterface con i dati passati."""
        try:
            return self.serial_interface_factory(port, baud, use_serial=True)
        except ValueError as e:
            raise ValueError(f"Baudrate non valido: {e}")

    # --- METODI DI BASSO LIVELLO (I/O) ---

    def _send_spi_word(self, ser_int: SerialInterface, word_value: int) -> bytes:
        """Funzione helper per inviare una singola parola di configurazione SPI."""
        # Inizializzazione SPI (avviene solo al primo accesso)
        if not self.spi_initialized:
            print("First access to SPI, performing initialization")
            # 1) SPI Init: Write VAL_SPI_INIT_1 to REG_SPI_INIT_1
            ser_int.write_register(REG_SPI_INIT_1, VAL_SPI_INIT_1)
            # 2) SPI Init: Write VAL_SPI_INIT_2 to REG_SPI_INIT_2
            ser_int.write_register(REG_SPI_INIT_2, VAL_SPI_INIT_2)
            self.spi_initialized = True
            print("SPI initialization complete")

        # 3) SPI CTRL Clear: Write VAL_SPI_CTRL_CLEAR to REG_SPI_CTRL
        ser_int.write_register(REG_SPI_CTRL, VAL_SPI_CTRL_CLEAR)
        # 4) SPI Data: Write config_value to REG_SPI_DATA
        ser_int.write_register(REG_SPI_DATA, word_value)
        # 5) SPI CTRL Set: Write VAL_SPI_CTRL_SET to REG_SPI_CTRL
        ser_int.write_register(REG_SPI_CTRL, VAL_SPI_CTRL_SET)
        # 7) SPI Read: Read from REG_SPI_DATA (per verifica/risposta)
        response = ser_int.read_register(REG_SPI_DATA)
        return response

    def send_write_command(self, port: str, baud: int, addr: int, data: int) -> str:
        """Invia un comando di scrittura al registro FPGA."""
        with self._get_serial_interface(port, baud) as ser_int:
            response = ser_int.write_register(addr, data)
            return " ".join(f"{b:02X}" for b in response)

    def send_read_command(self, port: str, baud: int, addr: int) -> str:
        """Invia un comando di lettura dal registro FPGA."""
        with self._get_serial_interface(port, baud) as ser_int:
            response = ser_int.read_register(addr)
            return " ".join(f"{b:02X}" for b in response)

    # --- METODI DI CONFIGURAZIONE DI ALTO LIVELLO ---
    
    def send_full_configuration(self, port: str, baud: int, config_str: str) -> str:
        """Invia una configurazione a 20 bit all'FPGA."""
        if len(config_str) != 20 or any(c not in '01' for c in config_str):
            raise ValueError("Configuration must be a 20-bit binary string.")
        
        config_value = int(config_str, 2)
        
        with self._get_serial_interface(port, baud) as ser_int:
            # Logica di SPI Init, Clear, Data, Set
            self._send_spi_word(ser_int, config_value)
            print(f"Configuration sent: {config_str}")
            # Leggi la risposta finale
            response = ser_int.read_register(REG_SPI_DATA)
            return " ".join(f"{b:02X}" for b in response)

    def send_injection_settings(self, port: str, baud: int, inj_params: Dict[str, int]):
        """Genera e invia le due parole di configurazione per l'iniezione."""
        
        word1, word2 = self.asic_config.get_injection_settings(
            bypass_1b=inj_params['bypass'], period_8b=inj_params['period'],
            burst_8b=inj_params['burst'], duty_4b=inj_params['duty']
        )

        with self._get_serial_interface(port, baud) as ser_int:
            # Invia la prima e la seconda parola (SPI WRITE INJ1 e INJ2)
            self._send_spi_word(ser_int, word1)
            self._send_spi_word(ser_int, word2)
            print("Injection settings sent successfully.")

    # --- METODI POWER SUPPLY ---
    
    def connect_power_supply(self, channel: int = 1):
        """Connette al Power Supply e lo prepara."""
        if not self.ps_service:
            print("Warning: Power Supply Service is not initialized (USE_SERIAL=True or not injected). Skipping connection.")
            return

        self.ps_service.connect(resource_index=0)
        self.ps_service.set_channel_current(channel, 0.1)
        print("Connected to Power Supply successfully.")
        
    def _prepare_power_supply_for_sweep(self):
        """Configura entrambi i canali del Power Supply per lo sweep."""
        if not self.ps_service:
            raise RuntimeError("Power Supply Service non disponibile.")
            
        # Canale 2 del power supply fisso a 0V 
        self.ps_service.set_channel_voltage(channel=2, voltage=0.0)
        self.ps_service.set_channel_current(channel=2, current=0.1)
        self.ps_service.output_on(channel=2)
        self.ps_service.set_channel_current(channel=1, current=0.1)

    def _shutdown_power_supply(self):
        """Spegne il canale 1 del Power Supply."""
        if self.ps_service:
            try:
                self.ps_service.output_off(channel=1)
                print("Power Supply turned off.")
            except Exception as e:
                print(f"Warning: Could not turn off Power Supply: {e}")

   
    def _inject_a_pixel(self, x: int, y: int, binary_command_params: Dict[str, int], ser_int: SerialInterface) -> Tuple[float, float]:
        """Esegue l'iniezione su un singolo pixel usando una connessione seriale pre-esistente."""
    

        # 2. Sequenza di comunicazione
        try:
            # Sequenza di configurazione pixel
            self._send_spi_word(ser_int, binary_command_params["pad_word"])
            self._send_spi_word(ser_int, binary_command_params["pointer_word"])
            self._send_spi_word(ser_int, binary_command_params["config_pixel_word"])
            # Sequenza di iniezione START
            self._send_spi_word(ser_int, binary_command_params["inj_word2_start"])
            self._send_spi_word(ser_int, binary_command_params["inj_word1_start"])
            # Richiesta ToT e ToA
            tot_response_raw = self._send_spi_word(ser_int, binary_command_params["tot_request"])
            toa_response_raw = self._send_spi_word(ser_int, binary_command_params["toa_request"])
            # Ripristino pixel dopo iniezione STOP
            self._send_spi_word(ser_int, binary_command_params["inj_word2_stop"])
            self._send_spi_word(ser_int, binary_command_params["inj_word1_stop"])

            # 3. Elabora risultati
            tot_value = self.asic_config.elaborate_received_tot(tot_response_raw)
            toa_value = self.asic_config.elaborate_received_toa(toa_response_raw)
            
            return tot_value, toa_value
        except Exception as e:
            raise Exception(f"Errore durante l'iniezione/lettura del pixel: {e}")

    def inject_single_pixel(self, port: str, baud: int, x: int, y: int, 
                            pixel_config_params: Dict[str, int], inj_params: Dict[str, int]) -> Tuple[float, float]:
        """Inietta un singolo pixel. Apre e chiude la seriale localmente."""
        with self._get_serial_interface(port, baud) as ser_int:
            tot_value, toa_value = self._inject_a_pixel(x, y, pixel_config_params, inj_params, ser_int)
            print(f"ToT={tot_value}\t ToA={toa_value}")
            return tot_value, toa_value
            
    def perform_sweep(self, port: str, baud: int, sweep_params: Dict[str, int], 
                      binary_command_params: Dict[str, int], pixel_config_params: Dict[str, int]) -> float:
        """Esegue una scansione completa variando la tensione di soglia."""

        all_sweep_data = []
        
        if not self.ps_service:
            raise RuntimeError("Impossibile eseguire lo sweep: Power Supply Service non disponibile (USE_SERIAL=True?).")
            
        start_voltage = sweep_params['start_v']
        end_voltage = sweep_params['end_v']
        step = sweep_params['step_v']
        num_injections = sweep_params['num_injections']
        pixel_x = sweep_params['pixel_x']
        pixel_y = sweep_params['pixel_y']

        if step <= 0:
            raise ValueError("Lo step di tensione deve essere un numero intero positivo.")
        if num_injections <= 0:
            raise ValueError("Il numero di iniezioni deve essere maggiore di zero.")
        
        try:
            # 1. Inizializzazione file di esportazione
            self.exporter.create_falaphel_file(pixel_config_params)

            # 2. Connessione e preparazione power supply
            self.connect_power_supply() # Usa l'iniezione per connettersi
            self._prepare_power_supply_for_sweep() 
            
            # 3. Genera la lista di tensioni
            sweep_step = -step if start_voltage > end_voltage else step
            stop_value = end_voltage - step if start_voltage > end_voltage else end_voltage + 1
            voltages = list(range(start_voltage, stop_value, sweep_step))
            
            print(f"Starting sweep injection for pixel X={pixel_x}, Y={pixel_y} ({len(voltages)} steps).")
            
            start_time = time.time()
            
            # *** Ottimizzazione principale: apro la connessione seriale UNA SOLA VOLTA ***
            with self._get_serial_interface(port, baud) as ser_int:
                self.ps_service.output_on(channel=1)

                for voltage in voltages:
                    tot_results: List[float] = []
                    toa_results: List[float] = []
                    print(f"--- Setting Vth to {voltage} mV ---")
                    
                    # Imposta la tensione e accendi
                    self.ps_service.set_channel_voltage(channel=1, voltage=voltage/1000.0)

                    remaining = num_injections
                    while remaining > 0:
                        tot_value, toa_value = self._inject_a_pixel(pixel_x, pixel_y, binary_command_params, ser_int)
                        
                        # Gestione dei risultati e retry/decremento (Logica di elaborazione)
                        if math.isnan(tot_value) and math.isnan(toa_value):
                            # Hit mancato -> canonicalize tot to 0.0
                            tot_results.append(0.0)
                            toa_results.append(math.nan)
                            remaining -= 1
                        elif not math.isnan(toa_value) and int(toa_value) == 255:
                            # ToA overflow -> retry without decrementing remaining
                            time.sleep(0.001)
                            continue 
                        else:
                            # Risultato valido
                            tot_results.append(tot_value)
                            toa_results.append(toa_value)
                            remaining -= 1

                        time.sleep(self.injection_delay) # Ritardo hardware

                    # 4. Calcolo delle statistiche
                    valid_tot_results = [r for r in tot_results if not math.isnan(r)]
                    valid_toa_results = [r for r in toa_results if not math.isnan(r)]

                    if not valid_tot_results:
                        avg_tot, std_tot = float('nan'), float('nan')
                    else:
                        avg_tot = statistics.mean(valid_tot_results)
                        # If only one result, set std to 0.0 to avoid statistics.StatisticsError
                        # This is mathematically correct, but statistics.stdev() would raise an exception.
                        std_tot = statistics.stdev(valid_tot_results) if len(valid_tot_results) > 1 else 0.0

                    if not valid_toa_results:
                        avg_toa, std_toa = float('nan'), float('nan')
                    else:
                        avg_toa = statistics.mean(valid_toa_results)
                        # If only one result, set std to 0.0 to avoid statistics.StatisticsError
                        std_toa = statistics.stdev(valid_toa_results) if len(valid_toa_results) > 1 else 0.0

                    # Calcola l'efficienza
                    num_hits_tot = sum(1 for tot in tot_results if tot > 0)
                    efficiency_tot = num_hits_tot / num_injections if num_injections > 0 else 0.0

                    num_hits_toa = sum(1 for toa in toa_results if toa > 0)
                    efficiency_toa = num_hits_toa / num_injections if num_injections > 0 else 0.0

                    data_row = {
                        'voltage': voltage, 'tot_avg': avg_tot, 'tot_std': std_tot,
                        'toa_avg': avg_toa, 'toa_std': std_toa, 'efficiency_tot': efficiency_tot,
                        'efficiency_toa': efficiency_toa
                    }
                    all_sweep_data.append(data_row)
                    print(f"Completed {num_injections} injections at {voltage} mV. AVG_ToT={avg_tot:.2f}, AVG_ToA={avg_toa:.2f}")
            # 6. SCRITTURA FINALE in BLOCCO
            # Note: If write_falaphel_data_bulk fails, the exception is intentionally allowed to propagate for GUI error handling.
            self.exporter.write_falaphel_data_bulk(all_sweep_data)
            end_time = time.time()
            elapsed_time = end_time - start_time
            print(f"Pixel injection sweep completed in {elapsed_time:.2f} seconds.")
            return elapsed_time


        except Exception as e:
            print(f"FATAL: Error during pixel injection sweep: {e}")
        finally:
            # Safe to call even if ps_service was never initialized or connected, due to internal check in _shutdown_power_supply.
            self._shutdown_power_supply() # Assicurati che l'alimentazione sia spenta
            self._shutdown_power_supply() # Assicurati che l'alimentazione sia spenta


    def perform_matrix_scan(self, port: str, baud: int, sweep_params: Dict[str, int], timing_injection_settings: Dict[str, int],
                           pixel_config_params: Dict[str, int]) -> Dict[str, Any]:
        """
        Esegue uno scan completo della matrice 8x32 pixel.
        Per ogni pixel, esegue un perform_sweep completo.

        Args:
            port: Porta seriale
            baud: Baudrate
            sweep_params: Parametri di sweep (start_v, end_v, step_v, num_injections)
                          Nota: pixel_x e pixel_y verranno sovrascritti
            timing_injection_settings: Impostazioni di temporizzazione per l'iniezione
            pixel_config_params: Template della configurazione pixel (verrà aggiornato per ogni pixel)
            
            sweep_params = {
                'start_v', 
                'step_v',
                'pixel_x',
                'pixel_y'
            }

            timing_injection_settings = {
                'bypass',
                'period',
                'burst',
                'duty'
            }

            pixel_config_params = {
                'cap25',
                'dac_th', 
                'test_en',
                'cap50',
                'cap_csa_load',
                't_up', 
                'out_en
            }

        Returns:
            Dizionario con statistiche dello scan completo.
            scan_stats = {
                'total_pixels',
                'successful_pixels',
                'failed_pixels',
                'total_time',
                'avg_time_per_pixel'
            }

        """
        matrix_rows = 8
        matrix_cols = 32
        total_pixels = matrix_rows * matrix_cols


        # Genera i comandi binari per il pixel corrente
        pad_word = self.asic_config.get_init_pad_string()

        # Initialize pointer_word for the first pixel (0,0); will be updated per-pixel in the loop
        #pointer_word = self.asic_config.get_pixel_pointer_selection(x_5b=0, y_3b=0)

        config_pixel_word = self.asic_config.get_config_pointed_pixel(
            cap25_1b=pixel_config_params['cap25'], dac_th_5b=pixel_config_params['dac_th'], test_en_1b=pixel_config_params['test_en'], 
            cap50_1b=pixel_config_params['cap50'], cap_csa_load_1b=pixel_config_params['cap_csa_load'], 
            t_up_1b=pixel_config_params['t_up'], out_en_1b=pixel_config_params['out_en']
        )

        inj_word1_start, inj_word2_start = self.asic_config.get_injection_settings(
            bypass_1b=timing_injection_settings['bypass'], period_8b=timing_injection_settings['period'], burst_8b=timing_injection_settings['burst'], duty_4b=timing_injection_settings['duty'], start_1b=1
        )
        inj_word1_stop, inj_word2_stop = self.asic_config.get_injection_settings(
            bypass_1b=timing_injection_settings['bypass'], period_8b=timing_injection_settings['period'], burst_8b=timing_injection_settings['burst'], duty_4b=timing_injection_settings['duty'], start_1b=0
        )
        tot_request = self.asic_config.get_save_tot_command()
        toa_request = self.asic_config.get_save_toa_command()

        print(f"Starting full matrix scan: {matrix_rows}x{matrix_cols} = {total_pixels} pixels")
        print(f"Voltage range: {sweep_params['start_v']}-{sweep_params['end_v']} mV, Step: {sweep_params['step_v']} mV")
        print(f"Injections per voltage: {sweep_params['num_injections']}")
        print(f"Starting full matrix scan: {matrix_rows}x{matrix_cols} = {total_pixels} pixels")
        print(f"Voltage range: {sweep_params['start_v']}-{sweep_params['end_v']} mV, Step: {sweep_params['step_v']} mV")
        print(f"Injections per voltage: {sweep_params['num_injections']}")


        scan_start_time = time.time()
        pixel_times = []
        failed_pixels = []

        for y in range(matrix_rows):
            for x in range(matrix_cols):
                pixel_num = y * matrix_cols + x + 1
                print(f"\n{'='*60}")
                print(f"Processing pixel {pixel_num}/{total_pixels}: X={x}, Y={y}")
                print(f"{'='*60}")

                # Aggiorna i parametri per il pixel corrente
                current_sweep_params = sweep_params.copy()
                current_sweep_params['pixel_x'] = x
                current_sweep_params['pixel_y'] = y

                current_pixel_config = pixel_config_params.copy()
                current_pointer_word = self.asic_config.get_pixel_pointer_selection(x_5b=x, y_3b=y)

                # Build binary_command_params for the current pixel
                current_binary_commands = {
                    'pad_word': pad_word,
                    'pointer_word': current_pointer_word,
                    'config_pixel_word': config_pixel_word,
                    'inj_word1_start': inj_word1_start,
                    'inj_word2_start': inj_word2_start,
                    'inj_word1_stop': inj_word1_stop,
                    'inj_word2_stop': inj_word2_stop,
                    'tot_request': tot_request,
                    'toa_request': toa_request
                }

                try:
                    elapsed = self.perform_sweep(
                        port, baud, current_sweep_params, 
                        current_binary_commands, current_pixel_config
                    )
                    pixel_times.append(elapsed)
                    print(f"Pixel ({x},{y}) completed successfully in {elapsed:.2f}s")

                except Exception as e:
                    print(f"ERROR: Failed to scan pixel ({x},{y}): {e}")
                    failed_pixels.append((x, y))
                    continue
                  
        scan_end_time = time.time()
        total_scan_time = scan_end_time - scan_start_time

        # Statistiche finali
        successful_pixels = total_pixels - len(failed_pixels)
        avg_pixel_time = statistics.mean(pixel_times) if pixel_times else 0.0

        scan_stats = {
            'total_pixels': total_pixels,
            'successful_pixels': successful_pixels,
            'failed_pixels': failed_pixels,
            'total_time': total_scan_time,
            'avg_time_per_pixel': avg_pixel_time
        }

        print(f"\n{'='*60}")
        print(f"MATRIX SCAN COMPLETED")
        print(f"{'='*60}")
        print(f"Total time: {total_scan_time:.2f}s ({total_scan_time/60:.2f} minutes)")
        print(f"Successful pixels: {successful_pixels}/{total_pixels}")
        print(f"Average time per pixel: {avg_pixel_time:.2f}s")
        if failed_pixels:
            print(f"Failed pixels: {failed_pixels}")

        return scan_stats