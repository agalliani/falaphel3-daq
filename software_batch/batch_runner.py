import yaml
import signal
import sys

from fpga_measurement_engine import FpgaMeasurementEngine
from asic_config import AsicConfigurator
from serial_interface import SerialInterface
from export_service import ExportService
from power_supply_controller import PowerSupplyService

from progress_reporter import ProgressReporter

from model.pixel_config import load_pixel_configs



# --- Classe per eseguire il batch ---
class BatchRunner:
    def __init__(self):
        # Inizializza l'attributo engine a None o in un modo appropriato
        self.engine = None
        self.cfg = None
        self.progress = ProgressReporter()   # reporter



    def run(self, config_path):
        """Esegue il batch di misurazioni basato sul file di configurazione."""
        
        # 1. Caricamento della configurazione
        with open(config_path) as f:
            self.cfg = yaml.safe_load(f)

        port = self.cfg["serial"]["port"]
        baud = self.cfg["serial"]["baud"]

        # FUNZIONE FACTORY per creare l'interfaccia seriale
        def serial_interface_factory(port: str, baud: int, use_serial: bool):
            # Il costruttore SerialInterface deve essere in grado di gestire l'emulazione
            return SerialInterface(port, baud, use_serial=use_serial)

        # 2. INIEZIONE DELLE DIPENDENZE NELL'ENGINE
        # Ora l'engine è correttamente assegnato all'istanza della classe (self)
        # istanzia il servizio di alimentazione (PowerSupplyService) così che i suoi metodi ricevano 'self'
        
        self.engine = FpgaMeasurementEngine(
            serial_interface_factory=serial_interface_factory,
            asic_config=AsicConfigurator(),
            exporter=ExportService(),
            ps_service=PowerSupplyService()
        )
        
        
        # Uso del metodo engine tramite self.engine
        self.engine.connect_power_supply() 
        self.engine._prepare_power_supply_for_sweep() 
        

        # === UNA SOLA progress bar per i task ===
        tasks_list = self.cfg["tasks"]
        task_main = self.progress.create_task("Batch tasks", total=len(tasks_list))
        # 3. Esecuzione dei task
        for i, task in enumerate(tasks_list):

            task_name = f"Task {i+1}/{len(tasks_list)}: {task['name']}"
            self.progress.update(task_main, description=task_name, advance=1)                 

            
            op = task["operation"]
            if op == "matrix_scan":
                p = task

                # recupera la configurazione del tuner se presente
                if p["tuner"]["enabled"] == True and  p["tuner"]["file"] != "None":
                    print(f"Loading tuner configuration from {p['tuner']['file']}")
                    configs = load_pixel_configs(p["tuner"]["file"])
                    self.engine.set_tuning_config(configs)

                    print(f"Loaded tuner config for task {p['name']}")



                sweep_params = p["sweep"]
                pixel_config_params = p["config"]
                injection_cfg = self.cfg["injection"]

                # Estraiamo le dimensioni per il totale
                matrix_rows = 8
                matrix_cols = 32
                total_pixels = matrix_rows * matrix_cols
                # Creiamo il task secondario, usiamo l'ID perché è più sicuro in rich
                scan_task_id = self.progress.create_task(f"Scan {i+1} Progress", total=total_pixels)

                # implementa possibilità di sweep lungo per la misura del tot anche ad alta carica
                if p["sweep"]["long_sweep_tot"] == True:
                    print("Long TOT sweep enabled.")
                    long_sweep_params = {
                        "start_long_v": p["sweep"]["long_sweep_range"]["start_long_v"],
                        "end_long_v": p["sweep"]["long_sweep_range"]["end_long_v"],
                        "step_long_v": p["sweep"]["long_sweep_range"]["step_long_v"]
                    }
                    print(f"Long TOT sweep params: {long_sweep_params}")
                    total_pixels, successful_pixels, failed_pixels, total_time, avg_time_per_pixel = self.engine.perform_matrix_scan(
                    port, baud,
                    sweep_params=sweep_params,
                    timing_injection_settings=injection_cfg,
                    pixel_config_params=pixel_config_params,
                    progress_reporter=self.progress,
                    scan_task_id=scan_task_id,
                    long_tot_sweep_params=long_sweep_params
                    )
                else:
                    total_pixels, successful_pixels, failed_pixels, total_time, avg_time_per_pixel = self.engine.perform_matrix_scan(
                    port, baud,
                    sweep_params=sweep_params,
                    timing_injection_settings=injection_cfg,
                    pixel_config_params=pixel_config_params,
                    progress_reporter=self.progress,
                    scan_task_id=scan_task_id
                    )

           
                print(f"Total pixels: {total_pixels}, Successful: {successful_pixels}, Failed: {failed_pixels}")
                print(f"Total time: {total_time} seconds, Average time per pixel: {avg_time_per_pixel} seconds")

            elif op == "submatrix_scan":

                p=task
                sweep_params = p["sweep"]
                pixel_config_params = p["config"]
                injection_cfg = self.cfg["injection"]

                # check che le dimensioni della sub-matrice siano valide
                if (p["submatrix"]["start_x"] < 0 or p["submatrix"]["start_y"] < 0 or
                    p["submatrix"]["width"] <= 0 or p["submatrix"]["height"] <= 0 or
                    p["submatrix"]["start_x"] + p["submatrix"]["width"] > 32 or
                    p["submatrix"]["start_y"] + p["submatrix"]["height"] > 8):
                    raise ValueError("Invalid sub-matrix dimensions or start coordinates.")
                else:
                    print(f"Starting sub-matrix scan at ({p['submatrix']['start_x']}, {p['submatrix']['start_y']}) "
                          f"with size {p['submatrix']['width']}x{p['submatrix']['height']}")

            
                
                    start_x = p["submatrix"]["start_x"]
                    start_y = p["submatrix"]["start_y"]
                    width = p["submatrix"]["width"]
                    height = p["submatrix"]["height"]

                    # Estraiamo le dimensioni per il totale
                    total_pixels = width * height
                    # Creiamo il task secondario, usiamo l'ID perché è più sicuro in rich
                    scan_task_id = self.progress.create_task(f"Scan {i+1} Progress", total=total_pixels)

                    total_pixels, successful_pixels, failed_pixels, total_time, avg_time_per_pixel = self.engine.perform_sub_matrix_scan(
                        port=port,
                        baud=baud,
                        sweep_params=sweep_params,
                        timing_injection_settings=injection_cfg,
                        pixel_config_params=pixel_config_params,
                        start_x=start_x,
                        start_y=start_y,
                        width=width,
                        height=height
                        )

                    messagebox.showinfo("Success", f"Sub-Matrix scan completed successfully. Size: {width}x{height}. Data saved to file.")

            else:
                raise ValueError(f"Unsupported op {op}")

        self.progress.stop()
            
# ============================================================================== 
# MAIN
# ============================================================================== 
def signal_handler(sig, frame):
    # La gestione del segnale deve spegnere il power supply
    # Questo richiede che il PowerSupplyService sia disponibile in questo contesto.

    print(f"Ctrl+C pressed. Exiting gracefully...")

    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

# --- Entry Point Principale ---
if __name__ == "__main__":
    # Creazione dell'istanza e chiamata del metodo run
    runner = BatchRunner()
    runner.run("scan_settings/batch_config_tuner.yaml")