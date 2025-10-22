# falaphel3-daq
Codebase for the firmware and software DAQ system of the FALAPHEL3 chip


The system is composed of the motherboard that hosts the chip, glued and wire-bonded to a daughter board. 
The motherboard is responsible to manage the DC levels, powering and communication to the FPGA, which is used to program the digital part of the chip through SPI interface.
Finally a python software is responsible to control the entire setup in order to characterize the chip.

PC --uart--> FPGA --spi--> CHIP


### Sequenza inizializzazione SPI PC-FPGA
sequenza di operazioni che bisogna fare per usare l'SPI:

1) write at address 30014 the value 0x7
2) write at address 30018 the value 0x1
3) write at address 30010 the value 0x2214
4) write at address 30000 the value 0x0 (for instance)
5) write at address 30010 the value 0x2314
6) write at address 30010 the value 0x2214
7) read  at address 30000 (answer from the chip)

Note:
- i primi 2 punti sono una tantum, non vanno ripetuti ad ogni accesso SPI, si possono fare all'inizio poi basta
- l'operazione 3 e la 6 sono di fatto la stessa cosa: ripuliscono il registro CTRL dopo ogni accesso SPI. Possiamo scegliere se farla all'inizio (step 3) o alla fine (step 6), ma penso che basti solo una delle 2
- l'accesso SPI vero e proprio avviene dopo avere eseguito il punto 5
- i 20 bit da passare al chip glieli si da' nel punto 4. Sopra ho messo 0 per esempio, ma puoi provare i valori che preferisci.


### Init SPI sul chip
comandi SPI da dare all'inizio:

1) PAD_CONFIG_WRITE
    01100000000000001010

        PAD_CONFIG_WRITE
        0110 0000000000001010
        ^^^^ └─────────────── 16 bit payload
        comando(6)
    Il comando è definito nel file TB_defines.sv PAD_CONFIG_WRITE 6

    Proviamo: 01100000000000000111


2) PAD_CONFIG_READ
    11100000000000000000
 
        PAD_CONFIG_READ
        1110 0000000000000000
        ^^^^ └─────────────── 16 bit payload
        comando (14)



#### Test systemVerilog
TB_defines.sv: definizione dei comandi SPI utilizzati negli altri file
TB_tasks.sv: in cui e' definito il comando spi_cmd
spi_cmd ha 2 ingressi: cmd (4b) e data (12b)
ma li manipola per farli diventare 20 bit: cmd (4b) - 0 (4b) - data (12b)

TB_configuration_tasks.sv: contiene la lista ordinata dei comandi SPI da
provare


### Draft
La definizione dei comandi da inviare è indicata nel file ```TB_defines.sv```.
Nel codice python la variabile che gestisce la stringa da 20-bit è ```config_value```

        config_value = xxxx  |  xxxxxxxxxxxxxxxx
                       4 bit       16 bit

Le operazioni essenziali da fare sono:

1. Settare il common mode e la corrente massima dei PAD di output del chip: ```PAD_CONFIG_WRITE```
2. Verificare l'avvenuta configurazione: ```PAD_CONFIG_READ```

Questi due punti forse possono essere fatti una tantum per sessione. O comunque ogni volta che il chip viene riacceso.

Dopodiché è necessario selezionare il pixel da testare, e inviargli la configurazione di lavoro.
In futuro sarà necessario automatizzare lo scan su tutta la matrice, che è grande 8 colonne x 32 righe. Per il momento analizziamo un pixel alla volta manualmente.

3. Imposta il puntatore al pixel da testare:

        config_value = SPI_WRITE_POINTER | 0011 | yyy | xxxxx
    ```yyy``` sono 3 bit che indicano la colonna selezionata

    ```xxxxx``` sono 5 bit che indicano la riga selezionata
    
    ```SPI_WRITE_POINTER``` è il comando che è definito in ```TB_defines.sv``` come 0000

    Quindi la parola da inviare sarà:

        config_value = 0000 0011 000 00000
        0000001100000000
    
4. Invia la configurazione al pixel selezionato

        config_value = SPI_WRITE_DATA | xxxxxxxxxxx | x
    ```yyy``` sono 3 bit che indicano la colonna selezionata

    ```xxxxx``` sono 5 bit che indicano la riga selezionata
    
    ```SPI_WRITE_DATA``` è il comando che è definito in ```TB_defines.sv``` come 0000

    Quindi la parola da inviare sarà:

        config_value = 0000 0011 000 00000

5. Controlla che la configurazione sia andata a buon fine, controllando quale configurazione è effettivamente stata impostata.

        config_value = SPI_READ_DATA | 000000000000
        config_value = 1001  0000 0000 0000


### Set iniettore

        inj_bypass = 1'b0;
        inj_period = 8'b00111111;
        inj_burst  = 8'b00111111;
        inj_duty   = 4'b0011;
        inj_start  = 1'b1;

```SPI_WRITE_INJ2 = 0011|0000|duty 4'|burst 8'``` invio per iniziare ```00110000001100000001```

```SPI_WRITE_INJ1 = 0010|0000|start 1'|bypass 1'|period 8'``` invio ```001000001011111111```


Per leggere il tot devo inviare il comando subito dopo l'iniezione: ```11000000000000000000```