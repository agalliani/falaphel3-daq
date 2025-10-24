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


# (Definizione di SpiCommand Enum come sopra)
# ...

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
        print("AsicConfigurator pronto.")


    def get_init_pad_string(self, slvs_drv_strg_4b: int = 0b1010, slvs_cmm_mode_4b: int = 0b0000) -> int:
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
        # (Omissis: le verifiche di range sono mantenute per chiarezza)

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
        # (Omissis: le verifiche di range sono mantenute per chiarezza)

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
            (burst_8b & 0x3F)
        )

        #print(f"Injection Settings word 1: {word20_1:020b}")
        #print(f"Injection Settings word 2: {word20_2:020b}")

        return word20_1, word20_2
    
    def get_save_tot_command(self):
        """
        Genera la parola per il comando di lettura TOT.
        [CMD(4)][0000(16)] = 20 bit
        """
        cmd = SpiCommand.TOT_READ

        word20 = (cmd.value << 16)
        print(f"TOT Read Command word: {word20:020b}")
        return word20

    def get_save_toa_command(self):
        """
        Genera la parola per il comando di lettura TOA.
        [CMD(4)][0000(16)] = 20 bit
        """
        cmd = SpiCommand.TOA_READ

        word20 = (cmd.value << 16)
        print(f"TOA Read Command word: {word20:020b}")
        return word20


    def resp_to_int(resp):
        if isinstance(resp, int):
            return resp
        if isinstance(resp, (bytes, bytearray)):
            return int.from_bytes(resp, byteorder='big') if resp else 0
        if isinstance(resp, (list, tuple)):
            return int.from_bytes(bytes(resp), byteorder='big') if resp else 0
        try:
            return int(resp)
        except Exception:
            return 0

    def elaborate_received_tot(self, tot_response):
        """
        Elabora i dati TOT ricevuti dall'ASIC.
        Restituisce il valore elaborato.

        TOT 12 bit word format:
        Bit 0-5: ToT data (6 bits)
        Bit 6-11: Not used (set to 0)

        "000000" | valid TOT (1 bit) | TOT value (5 bits)
        """

        # Estrai i 6 bit meno significativi
        i_tot = resp_to_int(tot_response)
        lsb6 = i_tot & 0x3F            # 0b111111 -> ultimi 6 bit
        validity_bit = (lsb6 >> 5) & 0x1  # MSB dei 6 bit (bit "6" nella descrizione)
        five_bit_value = lsb6 & 0x1F    # primi 5 bit (i 5 meno significativi del gruppo)

        if validity_bit == 1:
            print(f"ToT valid: 5-bit value = {five_bit_value} (bits {five_bit_value:05b})")
            return five_bit_value
        else:
            print("ToT not valid: NaN")
            return float('nan')

    def elaborate_received_toa(self, toa_response):
        """
        Elabora i dati TOA ricevuti dall'ASIC.
        Restituisce il valore elaborato.

        TOT 12 bit word format:
        Bit 0-8: ToT data (8 bits)
        Bit 9-11: Not used (set to 0)

        "000" | valid TOA (1 bit) | TOA value (8 bits)
        """

        # Estrai i 8 bit meno significativi
        i_tot = resp_to_int(tot_response)
        lsb8 = i_tot & 0xFF            # 0b11111111 -> ultimi 8 bit
        validity_bit = (lsb8 >> 7) & 0x1  # MSB dei 8 bit (bit "7" nella descrizione)
        eight_bit_value = lsb8 & 0x7F    # primi 7 bit (i 7 meno significativi del gruppo)

        if validity_bit == 1:
            print(f"ToT valid: 7-bit value = {eight_bit_value} (bits {eight_bit_value:07b})")
            return eight_bit_value
        else:
            print("ToT not valid: NaN")
            return float('nan')

# Se si volessero anche le funzionalità di comunicazione, 
# si potrebbero aggiungere metodi come 'send_word(self, word: int)' qui.