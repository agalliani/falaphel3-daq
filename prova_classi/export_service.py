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
    FALAPHEL_HEADER = "voltage\ttot_avg\ttot_std\ttoa_avg\ttoa_std\tefficiency\n"
    
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
    
    
    # --------------------------------------------------------------------------
    ## NUOVI METODI PER L'EXPORT SEMPLICE
    # --------------------------------------------------------------------------
    
    def create_falaphel_file(self):
        """
        Crea il file TSV richiesto con il nome e l'intestazione specificati.
        """
        # Formato data e ora richiesto: AA-MM-GG_HHMMSS (o simile a seconda di cosa intendi per {data}_{ora})
        # Usiamo: GGMMAA_HHMMSS
        timestamp = time.strftime("%y%m%d_%H%M%S")
        
        file_name = f"data_falaphel_prin_{timestamp}.tsv"
        target_path = self.directory / file_name
        self.falaphelPath = target_path # Salva il percorso per le scritture successive

        try:
            # Scrive l'intestazione al file
            with open(self.falaphelPath, "w") as file:
                file.write(self.FALAPHEL_HEADER)
            print(f"File '{file_name}' creato con successo in: {self.directory}")
            
        except Exception as e:
            print(f"Errore nella creazione del file: {e}")
            self.falaphelPath = None
            raise

        
    def write_falaphel_data_row(self, voltage: float, tot_avg: float, tot_std: float, toa_avg: float, toa_std: float, efficiency: float):
        """
        Scrive una riga di dati nel file 'data_falaphel_prin_{{...}}.tsv'.
        """
        if not self.falaphelPath or not self.falaphelPath.exists():
            print("Errore: Il file 'falaphel' non è stato creato. Chiama prima create_falaphel_file().")
            return 
        
        try:
            # Formatta i dati in una stringa TSV
            row = (
                f"{voltage}\t{tot_avg}\t{tot_std}\t"
                f"{toa_avg}\t{toa_std}\t{efficiency}\n"
            )
            
            # Scrivi in append
            with open(self.falaphelPath, "a") as file:
                file.write(row)
        except Exception as e:
            print(f"Errore nella scrittura del file 'falaphel': {e}")
            
