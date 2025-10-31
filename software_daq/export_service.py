import os
import time
from pathlib import Path


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


# ==============================================================================
# CLASSE EXPORT SERVICE (SINGLETON)
# ==============================================================================
class ExportService(metaclass=Singleton):
    
    # Costante per il nome della sottodirectory
    EXPORT_DIR_NAME = "export"
    
    # Intestazione specifica per il file 'data_falaphel_prin'
    FALAPHEL_HEADER = "voltage\ttot_avg\ttot_std\ttoa_avg\ttoa_std\tefficiency_tot\tefficiency_toa\n"

    def __init__(self):
        # Utilizza Path per una gestione dei percorsi moderna e cross-platform
        self.directory: Path = Path(os.getcwd()) / self.EXPORT_DIR_NAME
        
        # Percorso specifico per il file 'falaphel'
        self.falaphelPath: Path = None 
        
        # Assicurati che la directory di esportazione esista
        self._ensure_export_directory()
        
    def _ensure_export_directory(self):
        """Crea la directory di esportazione se non esiste."""
        try:
            os.makedirs(self.directory, exist_ok=True)
            print(f"Directory di esportazione creata/verificata: {self.directory}")
        except Exception as e:
            # È buona norma lanciare di nuovo l'eccezione se non riesci a creare la dir
            print(f"Errore nella creazione della directory di esportazione: {e}")
            raise

    def get_directory(self) -> str:
        """Restituisce il percorso assoluto della directory di esportazione."""
        return str(self.directory)
    
    
   
    
    def create_falaphel_file(self):
        """
        Crea il file TSV richiesto con suffissi dinamici basati sulle configurazioni attive.
        """

        # Ottieni valori dalle Tkinter IntVar
        cfg = {
            "cap50": self.config_cap50.get(),
            "cap25": self.config_cap25.get(),
            "cap_csa_load": self.config_cap_csa_load.get(),
            "dac_th": self.config_dac_th.get(),
            "test_en": self.config_test_en.get(),
            "t_up": self.config_t_up.get()
        }

        # Costruisci suffissi dinamici
        suffix_parts = []

        # campi booleani
        for key in ["cap50", "cap25", "cap_csa_load", "test_en", "t_up"]:
            if cfg[key] != 0:
                suffix_parts.append(f"_{key}")

        # campo multi-bit
        if cfg["dac_th"] != 0:
            suffix_parts.append(f"_dacth_{cfg['dac_th']}")

        suffix_string = "".join(suffix_parts)

        # Timestamp
        timestamp = time.strftime("%y%m%d_%H%M%S")

        file_name = f"data_falaphel_prin_{timestamp}{suffix_string}.tsv"
        target_path = self.directory / file_name
        self.falaphelPath = target_path

        try:
            with open(self.falaphelPath, "w") as file:
                file.write(self.FALAPHEL_HEADER)
            print(f"File '{file_name}' creato con successo in: {self.directory}")

        except Exception as e:
            print(f"Errore nella creazione del file: {e}")
            self.falaphelPath = None
            raise


        
    def write_falaphel_data_row(self, voltage: float, tot_avg: float, tot_std: float, toa_avg: float, toa_std: float, efficiency_tot: float, efficiency_toa: float):
        """
        Scrive una riga di dati nel file 'data_falaphel_prin_{{...}}.tsv'.
        """
        if not self.falaphelPath or not self.falaphelPath.exists():
            print("Errore: Il file 'falaphel' non è stato creato. Chiama prima create_falaphel_file().")
            return 
        
        try:
            # Formatta i dati in una stringa TSV
            row = (
                f"{round(voltage, 3)}\t{round(tot_avg, 3)}\t{round(tot_std, 3)}\t"
                f"{round(toa_avg, 3)}\t{round(toa_std, 3)}\t{round(efficiency_tot, 3)}\t{round(efficiency_toa, 3)}\n"
            )
            
            # Scrivi in append
            with open(self.falaphelPath, "a") as file:
                file.write(row)
        except Exception as e:
            print(f"Errore nella scrittura del file 'falaphel': {e}")
            
