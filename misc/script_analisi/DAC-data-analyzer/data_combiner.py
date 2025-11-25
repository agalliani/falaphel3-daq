# main.py
import pandas as pd
from pathlib import Path
import sys
# Non è necessario importare 're' se la logica viene semplificata.

def get_file_tags(filepath: Path) -> dict:
    """
    Estrae i tag 'tup' e 'tdac_code' dal nome del file.

    tup: 1 se 't_up' è nel nome, altrimenti 0.
    tdac_code: il numero intero che segue 'dacth_', altrimenti 0.
    """
    fname = filepath.name.lower()
    
    # Estrazione 'tup': 0 o 1 (booleano convertito in int)
    tup = int("t_up" in fname)
    
    # Estrazione 'tdac_code' con gestione dell'errore (pythonic: EAFP)
    tdac_code = 0
    dacth_prefix = "dacth_"
    
    try:
        # Tenta di trovare l'indice del prefisso e il numero successivo.
        if dacth_prefix in fname:
            # Dividi la stringa dopo il prefisso
            parts = fname.split(dacth_prefix)[1]
            # Estrai il numero (prima che inizi un altro carattere non-digit, o fine stringa)
            # Questo è più robusto e non richiede 're'
            num_str = "".join(filter(str.isdigit, parts))
            if num_str:
                tdac_code = int(num_str)
    except Exception:
        # Se qualcosa va storto nel parsing, lascia tdac_code a 0.
        pass
        
    return {"tup": tup, "tdac_code": tdac_code}


def read_tsv_with_tags(filepath: Path) -> pd.DataFrame:
    """
    Legge un singolo file TSV, estrae i tag dal nome e li aggiunge
    come colonne al DataFrame.
    """
    try:
        # Legge il file TSV
        df = pd.read_csv(filepath, sep='\t')
        
        # Estrae i tag
        tags = get_file_tags(filepath)
        
        # Aggiunge le colonne al DataFrame in modo efficiente (broadcasting)
        df["tup"] = tags["tup"]
        df["tdac_code"] = tags["tdac_code"]
        
        return df
    except Exception as e:
        # Gestione errori di lettura I/O o di parsing
        print(f"Errore durante la lettura o il tagging di '{filepath.name}': {e}")
        # Ritorna un DataFrame vuoto per non interrompere il processo
        return pd.DataFrame()


def main(data_dir: str = "data", output_file: str = "combined_data.csv") -> None:
    """
    Legge tutti i file TSV in una directory specificata, li combina in un 
    unico DataFrame Pandas e salva il risultato in un file CSV.
    """
    data_path = Path(data_dir)
    if not data_path.is_dir():
        print(f"Errore: La directory '{data_dir}' non esiste.")
        sys.exit(1)

    # List comprehension per trovare tutti i file .tsv nella directory.
    tsv_files = list(data_path.glob("*.tsv"))
    
    if not tsv_files:
        print(f"Nessun file .tsv trovato nella directory '{data_dir}'.")
        sys.exit(0)

    print(f"Trovati {len(tsv_files)} file TSV da combinare...")

    # Utilizza la funzione esplicita per leggere e taggare ogni file.
    # Questo è chiaro, manutenibile ed evita il monkey-patching.
    dataframes = [read_tsv_with_tags(f) for f in tsv_files]
    
    # Rimuove eventuali DataFrames vuoti risultanti da errori di lettura
    dataframes = [df for df in dataframes if not df.empty]

    if not dataframes:
        print("Nessun dato valido da combinare.")
        sys.exit(0)

    # Unisce tutti i DataFrames in un unico con pd.concat.
    combined_df = pd.concat(dataframes, ignore_index=True)
    
    # Salva il risultato per l'analisi successiva.
    combined_df.to_csv(output_file, index=False)
    
    print("-" * 30)
    print(f"✅ Dati combinati con successo in '{output_file}'")
    # Requisito: stampare a video il numero di righe e i nomi delle colonne
    print(f"   Righe totali: {len(combined_df)}")
    print(f"   Colonne: {', '.join(combined_df.columns)}")


# L'idioma standard per eseguire lo script.
if __name__ == "__main__":
    # La gestione degli argomenti da riga di comando è concisa e pythonic.
    input_dir = sys.argv[1] if len(sys.argv) > 1 else "data"
    
    main(data_dir=input_dir)