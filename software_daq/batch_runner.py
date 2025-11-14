import yaml
from fpga_measurement_engine import FpgaMeasurementEngine
from asic_config import AsicConfigurator
from serial_interface import SerialInterface
from export_service import ExportService

def run_batch(config_path):
    with open(config_path) as f:
        cfg = yaml.safe_load(f)

    engine = FpgaMeasurementEngine(
        serial_interface_factory=lambda port, baud, use_serial=True: SerialInterface(port, baud, use_serial),
        asic_config=AsicConfigurator(),
        exporter=ExportService(),
        ps_service=None
    )

    port = cfg["serial"]["port"]
    baud = cfg["serial"]["baud"]

    for task in cfg["tasks"]:
        op = task["operation"]

        if op == "sweep_pixel":
            p = task
            print(f"Running sweep: {p['name']}")

            sweep_params = p["sweep"]
            pixel_cfg = p["config"]

            engine.perform_sweep(
                port, baud,
                sweep_params=sweep_params,
                binary_command_params=None,   # lo generi nell’engine come già fai nella GUI
                pixel_config_params=pixel_cfg,
                isMatrixScan=False
            )

        elif op == "matrix_scan":
            ...
            # aggiungi logica

        else:
            raise ValueError(f"Unsupported op {op}")

if __name__ == "__main__":
    run_batch("batch_config.yaml")
