from pathlib import Path
import pandas as pd
from scipy.optimize import curve_fit
from scipy.special import erf
import numpy as np
import matplotlib.pyplot as plt

from scipy.optimize import curve_fit
from scipy.special import erf
import numpy as np
import matplotlib.pyplot as plt


path = "C:\\Users\\andre\\Documents\\Microlab\\Falaphel\\TOT-AFE\\BoardDAQ\\falaphel3-daq\\misc\\script_analisi\\DAC-data-analyzer\\data\\export_matrix_scan_251114_182242_cap50_cap_csa_load.tsv"

if not Path(path).exists():
    raise FileNotFoundError(f"File non trovato: {Path(path).resolve()}")

df = pd.read_csv(path, encoding="utf-8", engine="python", sep="\t")
#print(df.head())

# erf S-curve model
def myERF(x, mu, sigma):
    x = np.asarray(x)
    return 0.5 * (1.0 + erf((x - mu) / (sigma * np.sqrt(2.0))))


def fit_scurve(group):
    fit_results = {}
    for tdac_code, group in group:
        x_data = group['voltage'].values
        y_data = group['efficiency_toa'].values

        # initial guess for mu and sigma
        initial_guess = [np.median(x_data), max(1.0, (x_data.max() - x_data.min()) / 4.0)]

        try:
            popt, pcov = curve_fit(myERF, x_data, y_data,
                p0=initial_guess,
                bounds=([-np.inf, 1e-6], [np.inf, np.inf]),
                maxfev=5000,)
            fit_results[tdac_code] = popt  # store the fitted parameters
            

        except RuntimeError as e:
            print(f"    TDAC {tdac_code}: Fit failed: {e}")
 
    return fit_results



# reaggruppa i dati per pixel, ovvero per row e col uguali
grouped = df.groupby(['row', 'col'])
print(f"Numero di pixel unici: {len(grouped)}")

all_data = []

fit_results = {}
for (row, col), group in grouped:
    #print(f"Pixel (row={row}, col={col}): {len(group)} misure")

    #print(group.head())
    x_data = group['voltage'].values
    y_data = group['efficiency_toa'].values
    initial_guess = [np.median(x_data), max(1.0, (x_data.max() - x_data.min()) / 4.0)]

    try:
        popt, pcov = curve_fit(myERF, x_data, y_data,
            p0=initial_guess,
            bounds=([-np.inf, 1e-6], [np.inf, np.inf]),
            maxfev=5000,)
        fit_results[(row, col)] = popt  # store the fitted parameters
        all_data.append({
            'row': row,
            'col': col,
            'mu': round(popt[0], 2),
            'sigma': round(popt[1], 2)
        })
        #print(f"  Pixel (row={row}, col={col}): Fit results: mu={popt[0]}, sigma={popt[1]}")
    except RuntimeError as e:
        print(f"  Pixel (row={row}, col={col}): Fit failed: {e}")


tuner_df = pd.DataFrame(all_data)

target_mu = round(tuner_df['mu'].mean(), 2)

results = []
for row in tuner_df.itertuples():
    mu = row.mu
    error_mu = abs(target_mu - mu)
    # tup = 1 se il mu del pixel > target_mu (diminuire mu), altrimenti 0 (aumentare mu)
    tup = 0 if mu > target_mu else 1
    
    tdac_steps = (error_mu / 30.0)*31  # <---------------------------------------- modifica qui il fattore di scala per regolare la sensibilità del tuning

    #arrotonda tdac_steps all'intero più vicino
    tdac_steps = int(round(tdac_steps))
    
    # Inserisci i valori in una tupla
    results.append((int(row.row), int(row.col), tup, tdac_steps)) 

# crea un file tsv con le colonne: pixel_index, t_up_tuner, tdac_tuner
with open("tdac_tuning_results.tsv", "w") as f:
    f.write("row\tcol\tt_up_tuner\ttdac_tuner\n")
    for index, (row, col, t_up_tuner, tdac_tuner) in enumerate(results):
        f.write(f"{row}\t{col}\t{t_up_tuner}\t{tdac_tuner}\n")



plt.figure(figsize=(12, 4))
plt.subplot(1, 3, 1)
plt.grid()
plt.hist(tuner_df['mu'], bins=30, color='blue', alpha=0.7)
plt.annotate(
        f"Media: {tuner_df['mu'].mean():.2f}\nStd: {tuner_df['mu'].std():.2f}",
        xy=(0.98, 0.98), xycoords='axes fraction',
        ha='right', va='top',
        bbox=dict(boxstyle="round,pad=0.4", fc="yellow", alpha=0.6)
    )
plt.title('Distribuzione ddelle soglie')
plt.xlabel('Threshold [mV]')
plt.ylabel('Conteggio')
plt.subplot(1, 3, 2)
plt.grid()

plt.hist(tuner_df['sigma'], bins=30, color='orange', alpha=0.7)
plt.annotate(
        f"Media: {tuner_df['sigma'].mean():.2f}\nStd: {tuner_df['sigma'].std():.2f}",
        xy=(0.98, 0.98), xycoords='axes fraction',
        ha='right', va='top',
        bbox=dict(boxstyle="round,pad=0.4", fc="yellow", alpha=0.6)
    )
plt.title('Distribuzione deviazione standard delle soglie') 
plt.xlabel('Sigma [mV ]')
plt.ylabel('Conteggio')
plt.subplot(1, 3, 3)

# considera i tdac_steps associati a tup=1 come segnati negativi
tdac_steps = [ -tdac_steps if tup == 1 else tdac_steps for (_, _, tup, tdac_steps) in results]

plt.grid()

plt.hist(tdac_steps, bins=30, color='purple', alpha=0.7)
plt.annotate(
        f"Std: {np.std(tdac_steps):.2f}",
        xy=(0.98, 0.98), xycoords='axes fraction',
        ha='right', va='top',
        bbox=dict(boxstyle="round,pad=0.4", fc="yellow", alpha=0.6)
    )
plt.title('Distribuzione dei tdac_steps')
plt.xlabel('Tdac Steps (negativo: diminuire soglia, positivo: aumentare soglia)')
plt.ylabel('Conteggio')
plt.tight_layout()
plt.show()
