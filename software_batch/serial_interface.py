import serial 
# --- SERIAL INTERFACE CLASS (New, Separated Logic) ---
# --- CONSTANTS ---
# Command delimiters (Rimangono esterni, sono costanti di protocollo)
WRITE_CMD_START_BYTE = 0xA1
WRITE_CMD_END_BYTE = 0xA2
READ_CMD_START_BYTE = 0xB1
READ_CMD_END_BYTE = 0xB2

# --- DUMMY SERIAL CLASS ---
class DummySerial:
    def __init__(self, port, baudrate, timeout=1):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        print(f"DummySerial: opened {port} at {baudrate} baud")

    def write(self, data):
        # Stampa l'operazione in formato esadecimale
        #print(f"DummySerial WRITE: {data.hex()}")
        return

    def read(self, size):
        # Restituisce dati finti (esempio: 4 byte 0xDEADBEEF)
        response = bytes([0xDE, 0xAD, 0xBE, 0xEF][:size])
        #print(f"DummySerial READ: {response.hex()}")
        return response

    def close(self):
        print("DummySerial: closed")

class SerialInterface:
    """Gestisce la connessione seriale e il protocollo di comunicazione."""
    def __init__(self, port: str, baudrate: int, timeout: int = 1, use_serial: bool = False):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        self.use_serial = use_serial
        self.ser = None

    def __enter__(self):
        """Apre la connessione seriale usando il gestore di contesto (with)."""
        try:
            if self.use_serial:
                self.ser = serial.Serial(self.port, self.baudrate, timeout=self.timeout)
            else:
                self.ser = DummySerial(self.port, self.baudrate, timeout=self.timeout)
            return self
        except Exception as e:
            raise ConnectionError(f"Failed to open serial port {self.port}: {e}")

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Chiude la connessione seriale."""
        if self.ser:
            self.ser.close()

    def _send_command(self, command_bytes: bytes) -> bytes:
        """Logica di invio e ricezione interna, comune a lettura e scrittura."""
        if not self.ser:
             raise ConnectionError("Serial port not open.")
             
        self.ser.write(command_bytes)
        #print("Sent:", " ".join(f"{b:02X}" for b in command_bytes))
        
        # Legge 4 byte di risposta standard
        response = self.ser.read(4)
        ###print("Received:", " ".join(f"{b:02X}" for b in response)) ## unccomment for debug
        return response

    def write_register(self, address: int, data: int) -> bytes:
        """Crea e invia il pacchetto di scrittura."""
        packet = [
            WRITE_CMD_START_BYTE,
            (address >> 24) & 0xFF, (address >> 16) & 0xFF, (address >> 8) & 0xFF, address & 0xFF,
            (data >> 24) & 0xFF, (data >> 16) & 0xFF, (data >> 8) & 0xFF, data & 0xFF,
            WRITE_CMD_END_BYTE
        ]
        return self._send_command(bytes(packet))

    def read_register(self, address: int) -> bytes:
        """Crea e invia il pacchetto di lettura."""
        packet = [
            READ_CMD_START_BYTE,
            (address >> 24) & 0xFF, (address >> 16) & 0xFF, (address >> 8) & 0xFF, address & 0xFF,
            READ_CMD_END_BYTE
        ]
        return self._send_command(bytes(packet))
