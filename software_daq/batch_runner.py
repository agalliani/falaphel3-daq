import yaml
from fpga_measurement_engine import FpgaMeasurementEngine
from asic_config import AsicConfigurator
from serial_interface import SerialInterface
from export_service import ExportService
from power_supply_controller import PowerSupplyService

# --- Classe per eseguire il batch ---
class BatchRunner:
    def __init__(self):
        # Inizializza l'attributo engine a None o in un modo appropriato
        self.engine = None
        self.cfg = None

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




        # 3. Esecuzione dei task
        for task in self.cfg["tasks"]:
            op = task["operation"]

            if op == "sweep_pixel":
                p = task

                sweep_params = p["sweep"]
                pixel_cfg = p["config"]
                injection_cfg = self.cfg["injection"]

                pad_word = self.engine.asic_config.get_init_pad_string()
                pointer_word = self.engine.asic_config.get_pixel_pointer_selection(x_5b=pixel_cfg["x"], y_3b=pixel_cfg["y"])

                config_pixel_word = self.engine.asic_config.get_config_pointed_pixel(
                    cap25_1b=pixel_cfg["cap25"], dac_th_5b=pixel_cfg["dac_th"], test_en_1b=pixel_cfg["test_en"], 
                    cap50_1b=pixel_cfg["cap50"], cap_csa_load_1b=pixel_cfg["cap_csa_load"], 
                    t_up_1b=pixel_cfg["t_up"], out_en_1b=pixel_cfg["out_en"]
                )

                inj_word1_start, inj_word2_start = self.engine.asic_config.get_injection_settings(
                    bypass_1b=injection_cfg["bypass"], period_8b=injection_cfg["period"], burst_8b=injection_cfg["burst"], duty_4b=injection_cfg["duty"], start_1b=1
                )
                inj_word1_stop, inj_word2_stop = self.engine.asic_config.get_injection_settings(
                    bypass_1b=injection_cfg["bypass"], period_8b=injection_cfg["period"], burst_8b=injection_cfg["burst"], duty_4b=injection_cfg["duty"], start_1b=0
                )
                tot_request = self.engine.asic_config.get_save_tot_command()
                toa_request = self.engine.asic_config.get_save_toa_command()

                
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
                
                # Uso del metodo engine tramite self.engine
                self.engine.perform_sweep(
                    port, baud,
                    sweep_params=sweep_params,
                    binary_command_params=binary_command_params,
                    pixel_config_params=pixel_cfg,
                    isMatrixScan=False
                )

            #elif op == "matrix_scan":
            #   ...
            #   aggiungi logica

            else:
                raise ValueError(f"Unsupported op {op}")

# --- Entry Point Principale ---
if __name__ == "__main__":
    # Creazione dell'istanza e chiamata del metodo run
    runner = BatchRunner()
    runner.run("batch_config.yaml")