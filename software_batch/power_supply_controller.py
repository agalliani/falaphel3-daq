import logging
import pyvisa
from typing import Optional

logger = logging.getLogger(__name__)


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class PowerSupplyService(metaclass=Singleton):
    """Classe per il controllo di un Keysight E36300 Series Power Supply via PyVISA."""

    def __init__(self):
        self.rm = None
        self.instrument = None

    def __enter__(self):
        if self.instrument is None:
            self.connect()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

    def connect(self, resource_index: int = 0):
        """Connette lo strumento tramite VISA."""
        try:
            self.rm = pyvisa.ResourceManager()
            resources = self.rm.list_resources()
            if not resources:
                raise ConnectionError("Nessuno strumento VISA trovato.")
            if resource_index >= len(resources):
                raise IndexError(f"Indice risorsa {resource_index} fuori range (trovate {len(resources)})")

            self.instrument = self.rm.open_resource(resources[resource_index])
            idn = self.instrument.query("*IDN?")
            logger.info(f"Connesso a: {idn.strip()}")

            self.instrument.write("*RST")
            self.instrument.write("*CLS")

        except (pyvisa.VisaIOError, ConnectionError) as e:
            logger.exception(f"Errore di connessione allo strumento: {e}")
            self.close()
            raise

    def close(self):
        """Chiude la connessione in modo sicuro."""
        if self.instrument:
            self.instrument.close()
            self.instrument = None
        if self.rm:
            self.rm.close()
            self.rm = None
        logger.info("Connessione chiusa.")

    def _select_channel(self, channel: int):
        if channel not in (1, 2, 3):
            raise ValueError("Canale non valido: deve essere 1, 2 o 3.")
        self.instrument.write(f"INST:NSEL {channel}")

    def set_channel_voltage(self, channel: int, voltage: float):
        """Imposta la tensione in Volt sul canale specificato."""
        self._select_channel(channel)
        self.instrument.write(f"VOLT {voltage}")

    def set_channel_current(self, channel: int, current: float):
        """Imposta il limite di corrente in Ampere."""
        self._select_channel(channel)
        self.instrument.write(f"CURR {current}")

    def output_on(self, channel: Optional[int] = None):
        """Accende l'uscita: se channel è None, accende tutte le uscite."""
        if channel:
            self._select_channel(channel)
        self.instrument.write("OUTP ON")

    def output_off(self, channel: Optional[int] = None):
        """Spegne l'uscita: se channel è None, spegne tutte le uscite."""
        if channel:
            self._select_channel(channel)
        self.instrument.write("OUTP OFF")

    def measure_voltage(self, channel: int) -> float:
        """Legge la tensione erogata in Volt."""
        self._select_channel(channel)
        return float(self.instrument.query("MEAS:VOLT?"))

    def measure_current(self, channel: int) -> float:
        """Legge la corrente erogata in Ampere."""
        self._select_channel(channel)
        return float(self.instrument.query("MEAS:CURR?"))
