import serial
import tkinter as tk
from tkinter import filedialog, messagebox
import csv
import datetime

# Command delimiters: each one is a single-byte marker to define the start and end of a packet
WRITE_CMD_START_BYTE = 0xA1
WRITE_CMD_END_BYTE = 0xA2
READ_CMD_START_BYTE = 0xB1
READ_CMD_END_BYTE = 0xB2



USE_SERIAL = True  # True per usare la porta reale, False per emulare

ALREADY_ACCESSED_SPI = False  # Flag per evitare di accedere più volte alla SPI

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




    def send_write():
        ser = connect()
        if not ser: return
        try:
            addr = int(write_addr_entry.get(), 16)
            data = int(write_data_entry.get(), 16)
            log_to_monitor(f"Write Command: Addr=0x{addr:08X}, Data=0x{data:08X}", "write")
            response = write_command(ser, addr, data)
            if response:
                result = " ".join(f"{b:02X}" for b in response)
                log_to_monitor(f"Response: {result}", "other")
            else:
                log_to_monitor("No response", "other")
        except ValueError:
            messagebox.showerror("Error", "Invalid hex format")
        ser.close()

    def send_read():
        ser = connect()
        if not ser: return
        try:
            addr = int(read_addr_entry.get(), 16)
            log_to_monitor(f"Read Command: Addr=0x{addr:08X}", "read")
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

    def log_to_monitor(msg, tag="other"):
        now = datetime.datetime.now()
        timestamp = now.strftime("%H:%M:%S.%f")[:-3]  # ora:minuti:secondi.millisecondi
        monitor_text.config(state='normal')
        monitor_text.insert(tk.END, f"{timestamp} >> {msg}\n", tag)
        monitor_text.see(tk.END)
        monitor_text.config(state='disabled')

    def send_command_and_log(cmd_type, address, value=None):
        ser = connect()

        if cmd_type == "write":
            log_to_monitor(f"Write Command: Addr=0x{address:08X}, Data=0x{value:08X}", "write")
            write_command(ser, address, value)
        elif cmd_type == "read":
            log_to_monitor(f"Read Command: Addr=0x{address:08X}", "read")
            read_command(ser, address)
        else:
            log_to_monitor("Unknown command type", "other")
            return
        # Read ACK after each command
        ack = ser.read(4)
        if ack:
            result = " ".join(f"{b:02X}" for b in ack)
            log_to_monitor(f"ACK: {result}", "other")
            result_var.set(result)
        else:
            log_to_monitor("No ACK received", "other")
            result_var.set("")

    def send_configuration():
        global ALREADY_ACCESSED_SPI

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
            if ALREADY_ACCESSED_SPI==False:
                log_to_monitor(f"First access to SPI, performing initialization", "initialization")
                # 1) SPI Init: Write 0x7 to 0x30014
                send_command_and_log("write", 0x30014, 0x7)
                # 2) SPI Init: Write 0x1 to 0x30018
                send_command_and_log("write", 0x30018, 0x1)
                log_to_monitor(f"SPI initialization complete", "initialization")
                ALREADY_ACCESSED_SPI = True
            
            # 3) SPI CTRL Clear: Write 0x2214 to 0x30010
            log_to_monitor(f"SPI CTRL Clear", "explain")
            send_command_and_log("write", 0x30010, 0x2214)
            
            # 4) SPI Data: Write config_value to 0x30000
            log_to_monitor(f"SPI 20-bit Data Write: 0x{config_value:05X}", "explain")
            send_command_and_log("write", 0x30000, config_value)
            # 5) SPI CTRL Set: Write 0x2314 to 0x30010
            log_to_monitor(f"SPI CTRL Set", "explain")
            send_command_and_log("write", 0x30010, 0x2314)

            # 7) SPI Read: Read from 0x30000
            log_to_monitor(f"Answer from the chip", "explain")
            send_command_and_log("read", 0x30000)
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
    tk.Label(monitor_frame, text="Monitor (Commands & Results)", font=("Arial", 10, "bold")).pack(anchor="w")
    monitor_scrollbar = tk.Scrollbar(monitor_frame, orient="vertical")
    monitor_text = tk.Text(monitor_frame, width=80, height=25, state='disabled', yscrollcommand=monitor_scrollbar.set)
    monitor_text.tag_configure("initialization", foreground="purple")
    monitor_text.tag_configure("explain", foreground="orange")
    monitor_text.tag_configure("write", foreground="blue")
    monitor_text.tag_configure("read", foreground="green")
    monitor_text.tag_configure("other", foreground="black")
    monitor_scrollbar.config(command=monitor_text.yview)
    monitor_scrollbar.pack(side="right", fill="y")
    monitor_text.pack(fill="both", expand=True)
    monitor_frame.grid(row=0, column=2, rowspan=20, sticky="nswe", padx=(10, 0), pady=5)

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


