from pathlib import Path
import pandas as pd
import yaml
import numpy as np
from scipy.special import erf
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
import signal
import sys


TOA_CLOCK = 1.5625  # ns per tick
TOT_CLOCK = 25.0  # ns per tick

# ==============================================================================
# 1. FUNZIONI DI UTILITY/MODELLO (Nessun cambiamento)
# ==============================================================================

def myERF(x, mu, sigma):
    """Modello S-curve basato sulla funzione degli errori (ERF)."""
    x = np.asarray(x)
    return 0.5 * (1.0 + erf((x - mu) / (sigma * np.sqrt(2.0))))


def plot_histogram(fit_df, bins, figsize, color, column="threshold", file_name=""):
    """
    Disegna l'istogramma della colonna specificata dal dataframe dei fit.
    """
    if column not in fit_df.columns or fit_df[column].empty:
        print(f"Colonna '{column}' non presente o vuota in fit_df per {file_name}.")
        return None, None

    data = fit_df[column].dropna()
    if data.empty:
        print(f"Nessun valore in '{column}' disponibile per il plot dopo il dropna in {file_name}.")
        return None, None

    mean_val = data.mean()
    std_val = data.std()

    fig, ax = plt.subplots(figsize=figsize)
    ax.hist(data, bins=bins, color=color, alpha=0.7)
    
    # Impostazioni e annotazioni del grafico
    ax.set_title(f"Istogramma di '{column}'\n(File: {file_name})", fontsize=10)
    ax.set_xlabel(column.replace('_', ' ').title())
    ax.set_ylabel("Frequenza")
    ax.grid(True)
    
    ax.annotate(
        f"Media: {mean_val:.2f}\nStd: {std_val:.2f}",
        xy=(0.98, 0.98), xycoords='axes fraction',
        ha='right', va='top',
        bbox=dict(boxstyle="round,pad=0.4", fc="yellow", alpha=0.6)
    )

    # Linee per media e ±1σ
    ax.axvline(mean_val, color='r', linestyle='dashed', linewidth=1, label='μ')
    ax.axvline(mean_val + std_val, color='b', linestyle='dashed', linewidth=1, label='±1 σ')
    ax.axvline(mean_val - std_val, color='b', linestyle='dashed', linewidth=1)

    ax.legend(loc='best', fontsize='small')
    fig.tight_layout()
    return fig, ax


# ==============================================================================
# 2. FUNZIONI DI LOGICA PRINCIPALE (Modificate load_data e process_files)
# ==============================================================================

def load_data(script_path):
    """Carica la configurazione e restituisce la lista dei percorsi dei file dati."""
    # (Logica load_data invariata, verifica 'source_files' o 'source_file')
    config_path = script_path.with_name("config.yaml")
    if not config_path.exists():
        raise FileNotFoundError(f"config.yaml non trovato: {config_path.resolve()}")

    with config_path.open("r", encoding="utf-8") as f:
        cfg = yaml.safe_load(f) or {}

    file_names = cfg.get("source_files")
    if not file_names or not isinstance(file_names, list):
        single_file = cfg.get("source_file") 
        if single_file:
            file_names = [single_file]
        else:
            raise KeyError("Chiave 'source_files' o 'source_file' mancante/non valida in config.yaml")
        
    data_paths = []
    
    for file_name in file_names:
        data_path_str = "data/" + file_name
        path = Path(data_path_str)
        
        if not path.is_absolute():
            path = (config_path.parent / path).resolve()
        
        if not path.exists():
            print(f"ATTENZIONE: File dati non trovato: {path}. Saltato.")
            continue
        
        data_paths.append(path)

    if not data_paths:
        raise FileNotFoundError("Nessun file dati valido trovato da elaborare.")

    return data_paths, cfg


def process_files(data_paths, cfg, efficiency_col="efficiency_toa"):
    """
    Carica ed elabora tutti i file nella lista.
    Restituisce una lista di tuple: [(file_name, full_df, fit_df, fit_curves, all_data_points), ...]
    """
    results_per_file = []
    
    for i, path in enumerate(data_paths):
        file_name = path.name
        print(f"\n--- Elaborazione file {i+1}/{len(data_paths)}: {file_name} ---")
        try:
            # 1. Leggi il DataFrame
            df = pd.read_csv(path, sep="\t", encoding="utf-8", engine="python")
            df['source_file'] = file_name
            
            # 2. Esegui il Fit
            fit_df_single, fit_curves_single, all_data_points_single = fit_pixel_data(
                df, cfg, efficiency_col=efficiency_col
            )
            
            # Aggiorna il fit_df con il nome del file
            if not fit_df_single.empty:
                 fit_df_single['source_file'] = file_name
            
            results_per_file.append((file_name, df, fit_df_single, fit_curves_single, all_data_points_single))
            
        except Exception as e:
            print(f"Errore durante l'elaborazione di {file_name}: {e}")
            continue

    if not results_per_file:
        raise IOError("Nessun dato elaborato con successo.")
    
    return results_per_file


def fit_pixel_data(df, cfg, efficiency_col="efficiency_toa"):
    """
    Esegue il fitting dei dati per ogni pixel e raccoglie i risultati e le curve.
    (Funzione invariata - accetta df per un singolo file)
    """
    results = []
    fit_curves = []
    all_data_points = []
    voltage_threshold_max = cfg.get("voltage_threshold_max", np.inf)

    for (r, c), group in df.groupby(["row", "col"]):
        
        if efficiency_col not in group.columns:
            continue
            
        valid = group[["voltage", efficiency_col]].dropna()
        filtered = valid[valid["voltage"] < voltage_threshold_max]
        
        xdata = filtered["voltage"].values
        ydata = filtered[efficiency_col].values
        npts = len(xdata)

        if npts < 4:
            results.append({
                "row": r, "col": c, "metric": efficiency_col, "n_points": npts,
                "threshold": np.nan, "dispersion": np.nan, "success": False
            })
            continue
            
        all_data_points.append(filtered)
        guess = [np.median(xdata), max(1.0, (xdata.max() - xdata.min()) / 4.0)]

        try:
            popt, pcov = curve_fit(
                myERF, xdata, ydata, p0=guess,
                bounds=([-np.inf, 1e-6], [np.inf, np.inf]),
                maxfev=5000,
            )
            fit_mu, fit_sigma = float(popt[0]), float(popt[1])

            results.append({
                "row": r, "col": c, "metric": efficiency_col, "n_points": npts,
                "threshold": fit_mu, "dispersion": fit_sigma, "success": True
            })

            xs = np.linspace(xdata.min(), xdata.max(), 200)
            ys = myERF(xs, fit_mu, fit_sigma)
            fit_curves.append((xs, ys))

        except Exception:
            results.append({
                "row": r, "col": c, "metric": efficiency_col, "n_points": npts,
                "threshold": np.nan, "dispersion": np.nan, "success": False
            })

    fit_df = pd.DataFrame(results)
    print(f"Completati {len(fit_df)} fit di pixel per il file corrente.")
    return fit_df, fit_curves, all_data_points


def plot_file_results(file_name, full_df, fit_df, fit_curves, all_data_points, y_col_name, cfg):
    """
    Genera un set di plot (separati) per un singolo file, inclusa la legenda interattiva.
    """
    
    # Prendi le opzioni dei plot
    plot_cfg = cfg.get("plots", {})
    
    # ----------------------------------------------------------------------
    # Funzione di callback per la legenda interattiva
    # Definita come nested function per catturare le variabili locali (fig, lines, leg_artists)
    # ----------------------------------------------------------------------
    def toggle_visibility(event, lines, leg_lines, leg_artists, fig):
        """Nasconde/mostra la curva associata all'elemento di legenda cliccato."""
        
        if event.artist not in leg_artists:
            return
        
        try:
            # Trova l'indice dell'elemento cliccato (usa il modulo per gestire testo e linea insieme)
            index = leg_artists.index(event.artist) % len(lines)
        except ValueError:
            return

        line = lines[index]
        leg_artist = event.artist

        is_visible = not line.get_visible()
        line.set_visible(is_visible)
        
        alpha_value = 1.0 if is_visible else 0.2
        
        # Aggiorna la linea della legenda
        leg_lines[index].set_alpha(alpha_value)
        
        # Ridisegna il canvas per aggiornare la figura
        fig.canvas.draw()


    print(f"\nGenerazione plot per: {file_name}")
    
    # ----------------------------------------------------------------------
    # 1. Plot: Tutti i punti sperimentali
    # ----------------------------------------------------------------------
    if plot_cfg.get("data_points", False) and all_data_points:
        df_all_points = pd.concat(all_data_points, ignore_index=True)
        plt.figure(figsize=(6, 5))
        plt.scatter(
            df_all_points["voltage"], 
            df_all_points[y_col_name], 
            s=5, alpha=0.3, label="Dati sperimentali di tutti i pixel"
        )
        plt.title(f"Punti di Dati ({y_col_name})\n(File: {file_name})", fontsize=10)
        plt.xlabel("Voltage [mV]")
        plt.ylabel(y_col_name.replace('_', ' ').title())
        plt.grid(True)
        plt.tight_layout()
        print(" -> Creata figura: Punti di Dati.")


    # ----------------------------------------------------------------------
    # 2. Plot: S-curve dei fit sovrapposte
    # ----------------------------------------------------------------------
    if plot_cfg.get("fit_curves", False):
        plt.figure(figsize=(6, 5))
        for xs, ys in fit_curves:
            plt.plot(xs, ys, alpha=0.3)
        plt.title(f"Sovrapposizione dei fit (S-curves)\n(File: {file_name})", fontsize=10)
        plt.xlabel("Voltage [mV]")
        plt.ylabel("Efficiency (fit)")
        plt.grid(True)
        plt.tight_layout()
        print(" -> Creata figura: S-curves.")

    # ----------------------------------------------------------------------
    # 3. Plot: Istogrammi di Threshold e Dispersion
    # ----------------------------------------------------------------------
    if plot_cfg.get("histograms", False):
        plot_histogram(fit_df, 50, (6, 5), 'green', column="threshold", file_name=file_name)
        plot_histogram(fit_df, 50, (6, 5), 'orange', column="dispersion", file_name=file_name)
        print(" -> Create figure: Istogrammi.")

    # ----------------------------------------------------------------------
    # 4. Plot: Timer-over-threshold (INTERATTIVO)
    # ----------------------------------------------------------------------
    if plot_cfg.get("tot_vs_voltage", False):
        if "tot_avg" not in full_df.columns:
            print(" -> Colonna 'tot_avg' non presente in full_df; skip plot per-pixel Tot vs Voltage.")
        else:
            groups = list(full_df.groupby(["row", "col"]))
            if not groups:
                print(" -> Nessun pixel trovato in full_df per il plot Tot vs Voltage.")
            else:
                show_interactive_legend = len(groups) <= 20
                
                fig, ax = plt.subplots(figsize=(6, 5))
                lines = [] 
                
                for (r, c), grp in groups:
                    grp_sorted = grp.sort_values("voltage")
                    label = f"r{r},c{c}" if show_interactive_legend else None
                    
                    line, = ax.plot( 
                        grp_sorted["voltage"],
                        [x*TOT_CLOCK for x in grp_sorted["tot_avg"]],
                        marker='o', linestyle='-',
                        alpha=0.8 if show_interactive_legend else 0.25,
                        linewidth=0.8, markersize=3,
                        label=label
                    )
                    lines.append(line)
                    
                ax.set_title(f"Timer-over-threshold per pixel vs Voltage\n(File: {file_name})", fontsize=10)
                ax.set_xlabel("Voltage [mV]")
                ax.set_ylabel("Timer-over-Threshold [ns]")
                ax.grid(True)
                fig.tight_layout()
                
                if show_interactive_legend:
                    leg = ax.legend(fontsize="small", loc="best", fancybox=True, shadow=True)
                    leg_lines = leg.get_lines() 
                    leg_texts = leg.get_texts()
                    leg_artists = leg_lines + leg_texts

                    for item in leg_artists:
                        item.set_picker(5)
                    
                    # Usa lambda per passare le variabili locali a toggle_visibility
                    fig.canvas.mpl_connect(
                        'pick_event', 
                        lambda event: toggle_visibility(event, lines, leg_lines, leg_artists, fig)
                    )
                    print(" -> Creata figura: Timer-over-threshold (Legenda Cliccabile).")
                else:
                    print(" -> Creata figura: Timer-over-threshold (Non interattiva, troppi pixel).")

    # ----------------------------------------------------------------------
    # 5. Plot: Time-of-Arrival (INTERATTIVO)
    # ----------------------------------------------------------------------
    if plot_cfg.get("toa_vs_voltage", False):
        if "toa_avg" not in full_df.columns:
            print(" -> Colonna 'toa_avg' non presente in full_df; skip plot per-pixel ToA vs Voltage.")
        else:
            groups = list(full_df.groupby(["row", "col"]))
            if not groups:
                print(" -> Nessun pixel trovato in full_df per il plot ToA vs Voltage.")
            else:
                show_interactive_legend = len(groups) <= 20
                
                fig, ax = plt.subplots(figsize=(6, 5))
                lines = [] 
                
                for (r, c), grp in groups:
                    grp_sorted = grp.sort_values("voltage")
                    label = f"r{r},c{c}" if show_interactive_legend else None
                    
                    line, = ax.plot( 
                        grp_sorted["voltage"],
                        [x*TOA_CLOCK for x in grp_sorted["toa_avg"]],
                        marker='o', linestyle='-',
                        alpha=0.8 if show_interactive_legend else 0.25,
                        linewidth=0.8, markersize=3,
                        label=label
                    )
                    lines.append(line)
                    
                ax.set_title(f"Time-of-Arrival per pixel vs Voltage\n(File: {file_name})", fontsize=10)
                ax.set_xlabel("Voltage [mV]")
                ax.set_ylabel("Time-of-Arrival [ns]")
                ax.grid(True)
                fig.tight_layout()
                
                if show_interactive_legend:
                    leg = ax.legend(fontsize="small", loc="best", fancybox=True, shadow=True)
                    leg_lines = leg.get_lines() 
                    leg_texts = leg.get_texts()
                    leg_artists = leg_lines + leg_texts

                    for item in leg_artists:
                        item.set_picker(5)
                    
                    # Usa lambda per passare le variabili locali a toggle_visibility
                    fig.canvas.mpl_connect(
                        'pick_event', 
                        lambda event: toggle_visibility(event, lines, leg_lines, leg_artists, fig)
                    )
                    print(" -> Creata figura: Time-of-Arrival (Legenda Cliccabile).")
                else:
                    print(" -> Creata figura: Time-of-Arrival (Non interattiva, troppi pixel).")




# ==============================================================================
# 3. BLOCCO DI ESECUZIONE PRINCIPALE 
# ==============================================================================

if __name__ == "__main__":
    
    # Lista per tracciare se sono state create figure
    figures_created = False
    
    try:
        # Carica la configurazione e la lista dei path dei file
        data_paths, cfg = load_data(Path(__file__))
        
        efficiency_col_name = "efficiency_toa" 
        
        # Elabora TUTTI i file
        results_per_file = process_files(data_paths, cfg, efficiency_col=efficiency_col_name)

        # Genera i plot SEPARATAMENTE per ciascun file
        for file_name, full_df, fit_df, fit_curves, all_data_points in results_per_file:
            plot_file_results(file_name, full_df, fit_df, fit_curves, all_data_points, efficiency_col_name, cfg)
            figures_created = True # Imposta a True se almeno un set di plot è stato chiamato

        # Mostra tutti i plot accumulati
        if figures_created:
            plt.show()
        else:
            print("\nNessun plot generato. Controllare configurazione e dati.")

    except (FileNotFoundError, KeyError, IOError) as e:
        print(f"\nERRORE CRITICO: {e}")
    except Exception as e:
        print(f"\nErrore inatteso: {e}")