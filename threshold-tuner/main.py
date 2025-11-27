import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path
from scipy.optimize import curve_fit
from scipy.special import erf

# --- CONFIGURAZIONE ---
# Inserisci qui il percorso del tuo file
INPUT_FILE = Path(r"C:\\Users\\andre\\Documents\\Microlab\\Falaphel\\TOT-AFE\\BoardDAQ\\falaphel3-daq\\misc\\script_analisi\\DAC-data-analyzer\\data\\export_matrix_scan_251114_182242_cap50_cap_csa_load.tsv")
OUTPUT_FILE = Path("tdac_tuning_results.tsv")

# Parametri di Tuning
SCALE_FACTOR = 30.0   # mV corrispondenti alla base
TDAC_MULTIPLIER = 31  # Fattore di moltiplicazione per i passi

# --- FUNZIONI ---

def model_erf(x, mu, sigma):
    """
    Funzione Error Function (S-Curve).
    Restituisce la probabilità cumulativa di una distribuzione normale.
    """
    return 0.5 * (1.0 + erf((x - mu) / (sigma * np.sqrt(2.0))))

def load_data(file_path):
    """Carica i dati dal file TSV controllando che esista."""
    if not file_path.exists():
        raise FileNotFoundError(f"File non trovato: {file_path.resolve()}")
    
    return pd.read_csv(file_path, sep="\t", engine="python")

def fit_pixels(df):
    """
    Esegue il fit della curva S per ogni pixel (gruppo row/col).
    Restituisce un DataFrame con i risultati (mu, sigma) per ogni pixel.
    """
    results = []
    
    # Raggruppa per pixel
    grouped = df.groupby(['row', 'col'])
    print(f"Inizio analisi su {len(grouped)} pixel unici...")

    for (row, col), group in grouped:
        x_data = group['voltage'].values
        y_data = group['efficiency_toa'].values
        
        # Stima iniziale intelligente
        p0_guess = [
            np.median(x_data), 
            max(1.0, (x_data.max() - x_data.min()) / 4.0)
        ]

        try:
            # Esegui il fit
            popt, _ = curve_fit(
                model_erf, x_data, y_data,
                p0=p0_guess,
                bounds=([-np.inf, 1e-6], [np.inf, np.inf]), # Sigma deve essere > 0
                maxfev=5000
            )
            
            results.append({
                'row': int(row),
                'col': int(col),
                'mu': round(popt[0], 2),
                'sigma': round(popt[1], 2)
            })

        except RuntimeError:
            print(f"Fit fallito per Pixel (row={row}, col={col})")

    return pd.DataFrame(results)

def calculate_tuning(df_results, target_mu):
    """
    Calcola i parametri di tuning (t_up, tdac_steps) basandosi sulla differenza dal target.
    """
    # Calcolo differenza assoluta
    df_results['error_mu'] = (target_mu - df_results['mu']).abs()

    # Logica TUP: 0 se mu > target (bisogna scendere), 1 se mu < target (bisogna salire)
    df_results['t_up_tuner'] = np.where(df_results['mu'] > target_mu, 0, 1)

    # Calcolo TDAC steps
    steps_raw = (df_results['error_mu'] / SCALE_FACTOR) * TDAC_MULTIPLIER
    df_results['tdac_tuner'] = steps_raw.round().astype(int)

    return df_results

def plot_analysis(df, target_mu):
    """Genera i grafici per l'analisi dei risultati."""
    plt.figure(figsize=(15, 5))

    # 1. Istogramma Soglie (Mu)
    plt.subplot(1, 3, 1)
    plt.hist(df['mu'], bins=30, color='royalblue', alpha=0.7, edgecolor='black')
    plt.axvline(target_mu, color='red', linestyle='--', label=f'Target: {target_mu}')
    plt.title(f"Distribuzione Soglie (Mean: {df['mu'].mean():.2f} mV)")
    plt.xlabel('Soglia [mV]')
    plt.ylabel('Conteggio')
    plt.legend()
    plt.grid(alpha=0.3)

    # 2. Istogramma Rumore (Sigma)
    plt.subplot(1, 3, 2)
    plt.hist(df['sigma'], bins=30, color='orange', alpha=0.7, edgecolor='black')
    plt.title(f"Distribuzione Rumore (Mean: {df['sigma'].mean():.2f} mV)")
    plt.xlabel('Sigma [mV]')
    plt.grid(alpha=0.3)

    # 3. Istogramma Passi TDAC (con segno per visualizzazione)
    plt.subplot(1, 3, 3)
    # Creo una colonna temporanea per il grafico: negativo se t_up è 1 (come da logica originale)
    # Nota: ho interpretato la tua logica originale: "tdac_steps associati a tup=1 segnati negativi"
    signed_steps = np.where(df['t_up_tuner'] == 1, -df['tdac_tuner'], df['tdac_tuner'])
    
    plt.hist(signed_steps, bins=30, color='purple', alpha=0.7, edgecolor='black')
    plt.title(f"Distribuzione Correzione (Std: {np.std(signed_steps):.2f})")
    plt.xlabel('Step (< 0: tup=1, > 0: tup=0)')
    plt.grid(alpha=0.3)

    plt.tight_layout()
    plt.show()

# --- MAIN ---
if __name__ == "__main__":
    # 1. Caricamento Dati
    try:
        raw_data = load_data(INPUT_FILE)
    except FileNotFoundError as e:
        print(e)
        exit()

    # 2. Fitting
    results_df = fit_pixels(raw_data)

    if results_df.empty:
        print("Nessun fit completato con successo.")
        exit()

    # 3. Calcolo Tuning
    target_threshold = round(results_df['mu'].mean(), 2)
    print(f"Target calcolato (media): {target_threshold} mV")
    
    tuning_df = calculate_tuning(results_df, target_threshold)

    # 4. Esportazione CSV 
    cols_to_save = ['row', 'col', 't_up_tuner', 'tdac_tuner']
    tuning_df[cols_to_save].to_csv(OUTPUT_FILE, sep='\t', index=False)
    print(f"Risultati salvati in: {OUTPUT_FILE.resolve()}")

    # 5. Grafici
    plot_analysis(tuning_df, target_threshold)