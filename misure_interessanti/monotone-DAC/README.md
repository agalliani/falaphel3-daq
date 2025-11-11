### Indagine per il tuning della soglia

Per ciascun codice DAC disponibile devo:

1. fare sweep del pixel per trovare la distribuzione della hit probability
2. fare fit ERF e estrarre mu (soglia effettiva) e sigma (noise)
3. confrontare mu con la soglia target
4. trovare il codice che si avvicina meglio al target

#### Problema
    La variazione della soglia rispetto al DAC Code è monotona per tutti i pixel?

Per verificarlo devo ottenere un plot della soglia del pixel rispetto ai DAC codes.
Se la variazione della soglia è monotona, posso pensare di usare un algoritmo di ricerca binaria per trovare il codice ottimale. In caso contrario devo pensare a un metodo alternativo (coarse + local refine).

Valuto preliminarmente un solo pixel. Ho selezionato il pixel di coordinate (5,5), ipotizzando che essendo in una zona abbastanza centrale della matrice, non subisca eventuali effetti di bordo e che sia sufficientemente rappresentativo.

Eseguo uno sweep con cap50 abilitata in ingresso, soglia globale esterna impostata a 400mV e valuto per ciascun DAC Code + TUP la soglia media risultante.



