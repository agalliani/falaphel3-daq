
# ⚙️ File di configurazione scansioni

Questo documento descrive la struttura del file **YAML** utilizzato per configurare le **scansioni**, le **iniezioni** e i **parametri hardware** per il software di misura.
Serve come riferimento per modificare i parametri oppure creare nuove versioni del file.

---

## 1. Sezione `serial` 🔌

Questa sezione definisce la **porta seriale** e la **velocità di comunicazione** con il dispositivo.

```yaml
serial:
  port: "COM3"
  baud: 115200
````

| Campo | Descrizione |
| :--- | :--- |
| **`port`** | Porta seriale da usare. |
| **`baud`** | Baud rate della comunicazione. |

-----

## 2\. Sezione `injection` 💉

Parametri generali del **sistema di iniezione**, validi per tutte le scansioni (a meno che il task non gestisca override).

```yaml
injection:
  bypass: 0
  period: 63
  burst: 1
  duty: 8
```

| Campo | Descrizione |
| :--- | :--- |
| **`bypass`** | Abilita/disabilita il bypass. |
| **`period`** | Periodo del segnale di iniezione. |
| **`burst`** | Numero di burst per ciclo di test. |
| **`duty`** | Duty cycle del segnale. |

-----

## 3\. Sezione `tasks` 📋

La sezione più importante: contiene una **lista di test** da eseguire.
Ogni task è indipendente e definisce una particolare modalità di scansione o misura.

### Struttura Generale di un Task

```yaml
- name: <nome_task>
  operation: <tipo_operazione>
  <blocchi_opzionali>
```

Ogni task può includere:

  * blocco **`sweep`**
  * blocco **`config`**
  * blocco **`tuner`**
  * eventuali parametri specifici della `operation` (es. `submatrix`)

### 3.1 Task: `TEST_TOT_SCAN`

Esegue una scansione completa su un **singolo pixel** con possibilità di **sweep ToT esteso**.

#### Operazione

`operation: matrix_scan`

> Indica che la scansione percorre un set di valori di tensione per un pixel specifico.

#### Sweep

Definisce i parametri del ciclo di tensione:

```yaml
sweep:
  start_v: 100
  end_v: 40
  step_v: 3
  num_injections: 10
  pixel_x: 0
  pixel_y: 0
  long_sweep_tot: true
  long_sweep_range:
    start_long_v: 460
    end_long_v: 100
    step_long_v: 6
```

**Note principali:**

  * `start_v`, `end_v`, `step_v`: range principale di tensione.
  * `long_sweep_tot`: abilita sweep ToT esteso.
  * `long_sweep_range`: definisce un secondo sweep (utile per misure più profonde).

#### Config

Parametri del front-end e del pixel:

```yaml
config:
  dac_th: 0
  cap25: 0
  cap50: 0
  test_en: 1
  cap_csa_load: 1
  t_up: 0
  out_en: 1
  x: 0
  y: 0
```

#### Tuner

Consente di attivare il tuning tramite file esterno:

```yaml
tuner:
  enabled: true
  file: tuner_configs/tdac_tuning_results.tsv
```

-----

### 3.2 Task: `TEST_SUBMATRIX_SCAN`

Esegue una scansione su una **sub-matrice** anziché su un singolo pixel.

#### Operazione

`operation: submatrix_scan`

#### Submatrix

Definizione dell’area da scansionare:

```yaml
submatrix:
  start_x: 0
  start_y: 0
  width: 16
  height: 16
```

#### Sweep

Range di tensione specifico per questo task:

```yaml
sweep:
  start_v: 120
  end_v: 60
  step_v: 3
  num_injections: 10
  pixel_x: 16
  pixel_y: 16
  long_sweep_tot: false
```

#### Config

Parametri del front-end, identici al task precedente:

```yaml
config:
  dac_th: 0
  cap25: 0
  cap50: 0
  test_en: 1
  cap_csa_load: 1
  t_up: 0
  out_en: 1
  x: 0
  y: 0
```

#### Tuner

```yaml
tuner:
  enabled: false
```

-----

## 4\. Come creare una nuova versione del file 📝

Per aggiungere un nuovo task, copiare la struttura:

```yaml
- name: MY_NEW_TASK
  operation: <operation_type>
  <altri_blocchi_da_definire>
```

**Linee guida:**

  * **Ogni task è indipendente**: puoi modificare `sweep` o `config` senza toccare gli altri.
  * Mantieni **`name`** e **`operation`** chiari in modo che siano riconoscibili nel software.
  * Aggiungi solo le **sezioni necessarie**: `tuner` o `long sweep` sono opzionali.
  * I **commenti YAML** (`# testo`) sono utili per future revisioni.


