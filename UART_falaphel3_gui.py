import serial
import tkinter as tk
from tkinter import filedialog, messagebox
import csv

# Command delimiters: each one is a single-byte marker to define the start and end of a packet
WRITE_CMD_START_BYTE = 0xA1
WRITE_CMD_END_BYTE = 0xA2
READ_CMD_START_BYTE = 0xB1
READ_CMD_END_BYTE = 0xB2



USE_SERIAL = False  # True per usare la porta reale, False per emulare

class DummySerial:
    def __init__(self, port, baudrate, timeout=1):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        print(f"DummySerial: opened {port} at {baudrate} baud")

    def write(self, data):
        print(f"DummySerial: write {data.hex()}")

    def read(self, size):
        # Restituisce dati finti (esempio: 4 byte 0xDEADBEEF)
        print("DummySerial: returning dummy response")
        return bytes([0xDE, 0xAD, 0xBE, 0xEF][:size])

    def close(self):
        print("DummySerial: closed")



def send_command(ser, command_bytes):
    ser.write(command_bytes)
    print("Sent:", " ".join(f"{b:02X}" for b in command_bytes))
    response = ser.read(4)
    print("Received:", " ".join(f"{b:02X}" for b in response))
    return response

def write_command(ser, address, data):
    packet = [
        WRITE_CMD_START_BYTE,
        (address >> 24) & 0xFF, (address >> 16) & 0xFF, (address >> 8) & 0xFF, address & 0xFF,
        (data >> 24) & 0xFF, (data >> 16) & 0xFF, (data >> 8) & 0xFF, data & 0xFF,
        WRITE_CMD_END_BYTE
    ]
    return send_command(ser, bytes(packet))

def read_command(ser, address):
    packet = [
        READ_CMD_START_BYTE,
        (address >> 24) & 0xFF, (address >> 16) & 0xFF, (address >> 8) & 0xFF, address & 0xFF,
        READ_CMD_END_BYTE
    ]
    return send_command(ser, bytes(packet))

def process_csv_file(ser, filepath):
    with open(filepath, newline='') as csvfile:
        reader = csv.reader(csvfile)
        for address, row in enumerate(reader):
            if not row or not row[0].strip():
                continue
            try:
                data = int(row[0].strip(), 16)
                write_command(ser, address, data)
            except ValueError:
                print(f"Invalid data at row {address}: {row[0]}")

def start_gui():
    def connect():
        try:
            port = port_entry.get()
            baud = int(baud_entry.get())
            if USE_SERIAL:
                ser = serial.Serial(port, baud, timeout=1)
            else:
                ser = DummySerial(port, baud, timeout=1)
            return ser
        except Exception as e:
            messagebox.showerror("Error", str(e))
            return None


    def log_to_monitor(msg):
        monitor_text.config(state='normal')
        monitor_text.insert(tk.END, msg + "\n")
        monitor_text.see(tk.END)
        monitor_text.config(state='disabled')

    def send_write():
        ser = connect()
        if not ser: return
        try:
            addr = int(write_addr_entry.get(), 16)
            data = int(write_data_entry.get(), 16)
            log_to_monitor(f"Write Command: Addr=0x{addr:08X}, Data=0x{data:08X}")
            response = write_command(ser, addr, data)
            if response:
                result = " ".join(f"{b:02X}" for b in response)
                log_to_monitor(f"Response: {result}")
            else:
                log_to_monitor("No response")
        except ValueError:
            messagebox.showerror("Error", "Invalid hex format")
        ser.close()

    def send_read():
        ser = connect()
        if not ser: return
        try:
            addr = int(read_addr_entry.get(), 16)
            log_to_monitor(f"Read Command: Addr=0x{addr:08X}")
            response = read_command(ser, addr)
            if response:
                result = " ".join(f"{b:02X}" for b in response)
                log_to_monitor(f"Response: {result}")
            else:
                log_to_monitor("No response")
        except ValueError:
            messagebox.showerror("Error", "Invalid hex format")
        ser.close()

    def send_file():
        ser = connect()
        if not ser: return
        file_path = filedialog.askopenfilename()
        if file_path:
            if file_path.lower().endswith(".csv"):
                process_csv_file(ser, file_path)
        ser.close()

    def send_configuration():
        ser = connect()
        if not ser:
            return
        config_str = config_entry.get().strip()
        if len(config_str) != 20 or any(c not in '01' for c in config_str):
            messagebox.showerror("Error", "Configuration must be a 20-bit binary string")
            ser.close()
            return
        try:
            config_value = int(config_str, 2)
            log_to_monitor(f"1) SPI Init: Write 0x7 to 0x30014")
            write_command(ser, 0x30014, 0x7)
            log_to_monitor(f"2) SPI Init: Write 0x1 to 0x30018")
            write_command(ser, 0x30018, 0x1)
            log_to_monitor(f"3) SPI CTRL Clear: Write 0x2214 to 0x30010")
            write_command(ser, 0x30010, 0x2214)
            log_to_monitor(f"4) SPI Data: Write 0x{config_value:05X} to 0x30000")
            write_command(ser, 0x30000, config_value)
            log_to_monitor(f"5) SPI CTRL Set: Write 0x2314 to 0x30010")
            write_command(ser, 0x30010, 0x2314)
            log_to_monitor(f"6) SPI CTRL Clear: Write 0x2214 to 0x30010")
            write_command(ser, 0x30010, 0x2214)
            log_to_monitor(f"7) SPI Read: Read from 0x30000")
            response = read_command(ser, 0x30000)
            if response:
                result = " ".join(f"{b:02X}" for b in response)
                log_to_monitor(f"Response: {result}")
                result_var.set(result)
            else:
                log_to_monitor("No response")
                result_var.set("")
        except ValueError:
            messagebox.showerror("Error", "Invalid configuration format")
        ser.close()

    root = tk.Tk()
    root.title("UART Read/Write Tool")

    tk.Label(root, text="Serial Port:").grid(row=0, column=0)
    port_entry = tk.Entry(root)
    port_entry.insert(0, "COM3")
    port_entry.grid(row=0, column=1)

    tk.Label(root, text="Baudrate:").grid(row=1, column=0)
    baud_entry = tk.Entry(root)
    baud_entry.insert(0, "115200")
    baud_entry.grid(row=1, column=1)

    tk.Label(root, text="").grid(row=2, column=0, columnspan=2)
    tk.Frame(root, height=2, bd=1, relief=tk.SUNKEN).grid(row=2, column=0, columnspan=2, sticky="we", pady=5)

    section_label = tk.Label(root, text="Single commands section", font=("Arial", 10, "bold"))
    section_label.grid(row=2, column=0, columnspan=2, pady=(5, 10))

    tk.Label(root, text="Write Addr (hex):").grid(row=3, column=0)
    write_addr_entry = tk.Entry(root)
    write_addr_entry.grid(row=3, column=1)

    tk.Label(root, text="Write Data (hex):").grid(row=4, column=0)
    write_data_entry = tk.Entry(root)
    write_data_entry.grid(row=4, column=1)

    tk.Button(root, text="Send Write", command=send_write).grid(row=5, column=0, columnspan=2)

    tk.Label(root, text="Read Addr (hex):").grid(row=6, column=0)
    read_addr_entry = tk.Entry(root)
    read_addr_entry.grid(row=6, column=1)

    monitor_frame = tk.Frame(root, bd=2, relief=tk.GROOVE)
    monitor_frame.grid(row=0, column=2, rowspan=20, sticky="nswe", padx=(10, 0), pady=5)
    tk.Label(monitor_frame, text="Monitor (Commands & Results)", font=("Arial", 10, "bold")).pack(anchor="w")

    monitor_text = tk.Text(monitor_frame, width=60, height=25, state='disabled')
    monitor_text.pack(fill="both", expand=True)

    tk.Button(root, text="Send Read", command=send_read).grid(row=7, column=0, columnspan=2)

    tk.Label(root, text="Read Result:").grid(row=8, column=0)
    result_var = tk.StringVar()
    result_entry = tk.Entry(root, textvariable=result_var, state='readonly')
    result_entry.grid(row=8, column=1)

    tk.Label(root, text="").grid(row=10, column=0, columnspan=2)
    tk.Frame(root, height=2, bd=1, relief=tk.SUNKEN).grid(row=11, column=0, columnspan=2, sticky="we", pady=5)

    section_label = tk.Label(root, text="Send calibration string section", font=("Arial", 10, "bold"))
    section_label.grid(row=11, column=0, columnspan=2, pady=(5, 10))

    tk.Label(root, text="Configuration to be sent (20 bit):").grid(row=12, column=0)
    config_entry = tk.Entry(root)
    config_entry.insert(0, "0" * 20)
    config_entry.grid(row=12, column=1)

    tk.Button(root, text="Send Configuration", command=send_configuration).grid(row=14, column=0, columnspan=2, pady=10)

    root.mainloop()

if __name__ == "__main__":
    start_gui()


