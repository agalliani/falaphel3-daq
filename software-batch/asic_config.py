import enum

# Definisce i comandi SPI come un'enumerazione (Enum)
class SpiCommand(enum.IntEnum):
    """Comandi da inviare all'FPGA via UART (i primi 4 bit della stringa di configurazione)."""
    SPI_WRITE_POINTER = 0
    SPI_READ_POINTER = 8
    SPI_WRITE_DATA = 1
    SPI_READ_DATA = 9
    SPI_WRITE_INJ1 = 2
    SPI_READ_INJ1 = 10
    SPI_WRITE_INJ2 = 3
    SPI_READ_INJ2 = 11
    TOT_READ = 12
    TOA_READ = 13
    PAD_CONFIG_WRITE = 6
    PAD_CONFIG_READ = 14
    SPI_WRITE_STATUS = 7
    SPI_READ_STATUS = 15


class AsicConfigurator:
    """
    Gestisce la generazione delle parole di configurazione a 20 bit 
    da inviare all'ASIC.
    """

    def __init__(self, spi_interface=None):
        """
        Inizializza il configuratore. 
        Un'istanza dell'interfaccia di comunicazione (es. UART/SPI) 
        può essere passata qui.
        """
        self.spi_interface = spi_interface
        self.tuning_config = None

        print("AsicConfigurator pronto.")
        

    def set_tuning_config(self, config_matrix):
        self.tuning_config = config_matrix


    def get_init_pad_string(self, slvs_drv_strg_4b: int = 0b0110, slvs_cmm_mode_4b: int = 0b0000) -> int:
        """
        Genera la parola di configurazione per i PAD.
        [CMD(4)][0000(4)] [0000(4)] [slvs_cmm_mode(4)] [slvs_drv_strg(4)] = 20 bit
        """
        if not (0 <= slvs_drv_strg_4b < 16) or not (0 <= slvs_cmm_mode_4b < 16):
            raise ValueError("slvs_drv_strg o slvs_cmm_mode fuori range (0–15)")

        cmd = SpiCommand.PAD_CONFIG_WRITE

        word20 = (
            (cmd.value << 16) |
            (0x0 << 12) |
            (0x0 << 8) |
            ((slvs_cmm_mode_4b & 0xF) << 4) |
            (slvs_drv_strg_4b & 0xF)
        )
        #print(f"Config PAD word: {word20:020b}")
        return word20


    def get_pixel_pointer_selection(self, x_5b: int = 0b00000, y_3b: int = 0b000) -> int:
        """
        Genera la parola per la selezione del puntatore pixel (X, Y).
        [CMD(4)][0000(4)][0011][y(3)][x(5)] = 20 bit
        """
        if not (0 <= x_5b < 32):
            raise ValueError("x fuori range (0–31)")
        if not (0 <= y_3b < 8):
            raise ValueError("y fuori range (0–7)")

        cmd = SpiCommand.SPI_WRITE_POINTER

        word20 = (
            (cmd.value << 16) |
            (0x0 << 12) |
            (0x3 << 8) |
            ((y_3b & 0x7) << 5) |
            (x_5b & 0x1F)
        )
        #print(f"Pixel Pointer Selection word: {word20:020b}")
        return word20


    def get_config_pointed_pixel(self, cap25_1b: int = 0b0, dac_th_5b: int = 0b11111, test_en_1b: int = 0b1, cap50_1b: int = 0b0, cap_csa_load_1b: int = 0b0, t_up_1b: int = 0b0, out_en_1b: int = 0b1) -> int:
        """
        Genera la parola per la configurazione del pixel puntato.
        [CMD(4)][0000(4)][0(1)][cap25(1)][dac_th(5)][test_en(1)][cap50(1)][cap_csa_load(1)][t_up(1)][out_en(1)] = 20 bit
        """
        # (Omissis: le verifiche di range non cambiano)

        cmd = SpiCommand.SPI_WRITE_DATA

        word20 = (
            (cmd.value << 16) |
            (0x0 << 12) |
            (0x0 << 11) |
            ((cap25_1b & 0x1) << 10) |
            ((dac_th_5b & 0x1F) << 5) |
            ((test_en_1b & 0x1) << 4) |
            ((cap50_1b & 0x1) << 3) |
            ((cap_csa_load_1b & 0x1) << 2) |
            ((t_up_1b & 0x1) << 1) |
            (out_en_1b & 0x1)
        )
        #print(f"Config Pointed Pixel word: {word20:020b}")
        return word20


    def get_injection_settings(self, bypass_1b: int = 0b0, period_8b: int = 0b00111111, burst_8b: int = 0b00000001, duty_4b: int = 0b1000, start_1b: int = 0b0) -> tuple[int, int]:
        """
        Genera le due parole a 20 bit per la configurazione dell'iniezione.
        """
        # (Omissis: le verifiche di range non cambiano)

        # Prima parola: [CMD(4)][0000(4)][00(2)][start(1)][bypass(1)][period(8)]
        cmd1 = SpiCommand.SPI_WRITE_INJ1
        word20_1 = (
            (cmd1.value << 16) |
            (0x0 << 12) |
            (0x0 << 10) |
            ((start_1b & 0x1) << 9) |
            ((bypass_1b & 0x1) << 8) |
            (period_8b & 0xFF)
        )

        # Seconda parola: [CMD(4)][0000(4)][duty(4)][burst(8)]
        cmd2 = SpiCommand.SPI_WRITE_INJ2
        word20_2 = (
            (cmd2.value << 16) |
            (0x0 << 12) |
            ((duty_4b & 0xF) << 8) |
            # Nota: 'burst_8b & 0x3F' suggerisce 6 bit. 
            # Ho lasciato 6 bit come nel codice originale per coerenza con 0x3F (6 bit), 
            # anche se il commento diceva 8 bit.
            (burst_8b & 0x3F) 
        )

        #print(f"Injection Settings word 1: {word20_1:020b}")
        #print(f"Injection Settings word 2: {word20_2:020b}")

        return word20_1, word20_2
    
    def get_save_tot_command(self) -> int:
        """
        Genera la parola per il comando di lettura TOT.
        [CMD(4)][0000(16)] = 20 bit
        """
        cmd = SpiCommand.TOT_READ

        word20 = (cmd.value << 16)
        #print(f"TOT Read Command word: {word20:020b}")
        return word20

    def get_save_toa_command(self) -> int:
        """
        Genera la parola per il comando di lettura TOA.
        [CMD(4)][0000(16)] = 20 bit
        """
        cmd = SpiCommand.TOA_READ

        word20 = (cmd.value << 16)
        #print(f"TOA Read Command word: {word20:020b}")
        return word20


    def resp_to_int(self, resp) -> int:
        """
        Converte una risposta grezza (bytes, list, tuple, o int) in un intero.
        """
        if isinstance(resp, int):
            return resp
        # Assumiamo che la risposta UART sia composta da 4 byte, 
        # dove solo il LSB contiene la risposta 20 bit (o il ToT/ToA)
        if isinstance(resp, (bytes, bytearray)):
            # Prende solo gli ultimi 3 byte (24 bit) o 4 byte se è 32 bit, 
            # e li converte in un intero.
            return int.from_bytes(resp, byteorder='big') if resp else 0
        if isinstance(resp, (list, tuple)):
            return int.from_bytes(bytes(resp), byteorder='big') if resp else 0
        try:
            return int(resp)
        except Exception:
            return 0
# ----------------------------------------------------------------------
## Correzione di elaborate_received_tot
# ----------------------------------------------------------------------
    def elaborate_received_tot(self, tot_response) -> float:
        """
        Elabora i dati TOT ricevuti dall'ASIC.
        Restituisce il valore elaborato (float per 'nan' se non valido).

        TOT 12 bit word format (risposta 12 bit):
        [0000(4)] [00(2)] [valid TOT (1 bit)] [TOT value (5 bits)]
        Quindi: [12 bit non usati] [4 bit CMD] [4 bit non usati] | [6 bit TOT data]
        Assumiamo che la risposta completa sia 20 bit e vogliamo i 6 LSB.
        
        Format: "000000" | valid TOT (1 bit) | TOT value (5 bits)
        """
        #print(f"Raw TOT response: {self.resp_to_int(tot_response):020b}")

        # Estrai l'intera parola intera dalla risposta
        i_resp = self.resp_to_int(tot_response)
        
        # Isola i 6 bit di dato/validità (LSB della parola a 20 bit)
        lsb6 = i_resp & 0x3F             # 0b00000000000000111111 -> Isoliamo gli ultimi 6 bit
        
        # Il bit di validità è il bit 5 del gruppo (il 6° bit)
        validity_bit = (lsb6 >> 5) & 0x1 
        
        # Il valore TOT è dato dai 5 bit meno significativi
        five_bit_value = lsb6 & 0x1F     # 0b00011111 -> Isoliamo gli ultimi 5 bit

        if validity_bit == 1:
            # print(f"ToT valid: 5-bit value = {five_bit_value} (bits {five_bit_value:05b})")
            return float(five_bit_value)
        else:
            # print("ToT not valid: NaN")
            return float('nan')

    def elaborate_received_toa(self, toa_response) -> float:
        """
        DA CONTROLLARE!
        
        Elabora i dati TOA ricevuti dall'ASIC.
        Restituisce il valore elaborato (float per 'nan' se non valido).

        TOA 12 bit word format (risposta 12 bit):
        [000(3)] [valid TOA (1 bit)] [TOA value (8 bits)]
        
        Format: "000" | valid TOA (1 bit) | TOA value (8 bits)

        Elabora i dati TOA ricevuti dall'ASIC.
        Restituisce il valore elaborato (float per 'nan' se non valido).

        """

        # 1. Estrai l'intera parola intera dalla risposta
        #print(f"Raw TOA response: {self.resp_to_int(toa_response):020b}")
        i_resp = self.resp_to_int(toa_response)
        
        # 2. Isola i 9 bit di dato/validità (LSB della parola a 20 bit)
        # 9 bit totali: 1 bit validità (bit 8) + 8 bit dato (bit 0-7)
        lsb9 = i_resp & 0x1FF             # 0b00000000000000111111111 -> Isoliamo gli ultimi 9 bit
        
        # 3. Il bit di validità è il bit 8 del gruppo (il 9° bit)
        validity_bit = (lsb9 >> 8) & 0x1 
        
        # 4. Il valore TOA è dato dagli 8 bit meno significativi
        eight_bit_value = lsb9 & 0xFF     # 0b11111111 -> Isoliamo gli ultimi 8 bit

        if validity_bit == 1:
            # print(f"ToA valid: 8-bit value = {eight_bit_value} (bits {eight_bit_value:08b})")
            return float(eight_bit_value)
        else:
            # print("ToA not valid: NaN")
            return float('nan')

