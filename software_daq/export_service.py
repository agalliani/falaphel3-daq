import os
import time
from pathlib import Path
from typing import List, Dict, Any


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
    
    
   
    
    def create_falaphel_file(self, config):
        """
        config: dict con le configurazioni (interi)
        """
        suffix_parts = []
        # boolean flags
        for key in ["cap50", "cap25", "cap_csa_load", "t_up"]:
            if config.get(key, 0) != 0:
                suffix_parts.append(f"_{key}")
        # multi-bit
        dac_th = config.get("dac_th", 0)
        if dac_th != 0:
            suffix_parts.append(f"_dacth_{dac_th}")
        suffix_string = "".join(suffix_parts)
        timestamp = time.strftime("%y%m%d_%H%M%S")
        file_name = f"data_falaphel_prin_{timestamp}{suffix_string}.tsv"
        target_path = self.directory / file_name
        self.falaphelPath = target_path
        try:
            with open(self.falaphelPath, "w") as file:
                file.write(self.FALAPHEL_HEADER)
            print(f"File '{file_name}' creato in: {self.directory}")
        except Exception as e:
            print(f"Errore: {e}")
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
            
    
    def write_falaphel_data_bulk(self, data_rows: List[Dict[str, Any]]):
        """
        Scrive tutte le righe di dati fornite sul file 'data_falaphel_prin_{...}.tsv' 
        in un'unica operazione per ottimizzare l'I/O su disco.
        
        Args:
            data_rows: Lista di dizionari, dove ogni dizionario contiene
                       i dati di una riga (voltage, tot_avg, ecc.).
        """
        if not self.falaphelPath or not self.falaphelPath.exists():
            print("Errore: Il file 'falaphel' non è stato creato. Chiama prima create_falaphel_file().")
            return 
        
        # 1. Costruisci un'unica stringa contenente tutte le righe
        full_content = ""
        try:
            for row_data in data_rows:
                # Recupera i dati dal dizionario
                voltage = row_data['voltage']
                tot_avg = row_data['tot_avg']
                tot_std = row_data['tot_std']
                toa_avg = row_data['toa_avg']
                toa_std = row_data['toa_std']
                efficiency_tot = row_data['efficiency_tot']
                efficiency_toa = row_data['efficiency_toa']
                
                # Formatta la riga (come nel tuo metodo originale)
                row = (
                    f"{round(voltage, 3)}\t{round(tot_avg, 3)}\t{round(tot_std, 3)}\t"
                    f"{round(toa_avg, 3)}\t{round(toa_std, 3)}\t{round(efficiency_tot, 3)}\t{round(efficiency_toa, 3)}\n"
                )
                full_content += row
            
            # 2. Operazione di I/O UNICA
            with open(self.falaphelPath, "a") as file:
                # Scrivi tutto il contenuto in blocco
                file.write(full_content)
                
            print(f"Scritte {len(data_rows)} righe di dati in blocco su {self.falaphelPath.name}")

        except Exception as e:
            print(f"Errore nella scrittura BULK del file 'falaphel': {e}")



    
    def create_matrix_scan_file(self, config):
        """
        Crea un file per i dati dello scan della matrice.
        config: dict con le configurazioni (interi)
        """
        suffix_parts = []
        # boolean flags
        for key in ["cap50", "cap25", "cap_csa_load", "t_up"]:
            if config.get(key, 0) != 0:
                suffix_parts.append(f"_{key}")
        
        # multi-bit
        dac_th = config.get("dac_th", 0)
        if dac_th != 0:
            suffix_parts.append(f"_dacth_{dac_th}")
        suffix_string = "".join(suffix_parts)
        timestamp = time.strftime("%y%m%d_%H%M%S")
        file_name = f"export_matrix_scan_{timestamp}{suffix_string}.tsv"
        target_path = self.directory / file_name
        self.matrixScanPath = target_path
        try:
            with open(self.matrixScanPath, "w") as file:
                # Personalizza l'intestazione secondo i dati della matrice
                header = "row\tcol\tvoltage\ttot_avg\ttot_std\ttoa_avg\ttoa_std\tefficiency_tot\tefficiency_toa\n"
                file.write(header)
            print(f"File '{file_name}' creato in: {self.directory}")
        except Exception as e:
            print(f"Errore: {e}")
            self.matrixScanPath = None
            raise

    def write_matrix_scan_data_bulk(self, data_rows: List[Dict[str, Any]]):
        """
        Scrive i dati dello scan della matrice in blocco.
        
        Args:
            data_rows: Lista di dizionari con i dati (row, col, tot_avg, ecc.)
        """
        if not hasattr(self, 'matrixScanPath') or not self.matrixScanPath or not self.matrixScanPath.exists():
            print("Errore: Il file matrix scan non è stato creato. Chiama prima create_matrix_scan_file().")
            return 
        
        full_content = ""
        try:
            # Salta il primo elemento della lista (non si modifica l'array originale)
            for row_data in data_rows[1:]:
                row = row_data['row']
                col = row_data['col']
                voltage = row_data['voltage']
                tot_avg = row_data['tot_avg']
                tot_std = row_data['tot_std']
                toa_avg = row_data['toa_avg']
                toa_std = row_data['toa_std']
                efficiency_tot = row_data['efficiency_tot']
                efficiency_toa = row_data['efficiency_toa']
                
                line = (
                    f"{row}\t{col}\t{voltage}\t{round(tot_avg, 3)}\t{round(tot_std, 3)}\t"
                    f"{round(toa_avg, 3)}\t{round(toa_std, 3)}\t{round(efficiency_tot, 3)}\t{round(efficiency_toa, 3)}\n"
                )
                full_content += line
            
            with open(self.matrixScanPath, "a") as file:
                file.write(full_content)
                
            print(f"Scritte {len(data_rows)} righe di dati matrix scan in blocco su {self.matrixScanPath.name}")

        except Exception as e:
            print(f"Errore nella scrittura BULK del file matrix scan: {e}")