import serial
import tkinter as tk
from tkinter import filedialog, messagebox

# Command delimiters: each one is a single-byte marker to define the start and end of a packet
WRITE_CMD_START_BYTE = 0xA1
WRITE_CMD_END_BYTE = 0xA2
READ_CMD_START_BYTE = 0xB1
READ_CMD_END_BYTE = 0xB2

def send_command(ser, command_bytes):
    # Send the command to the serial port
    ser.write(command_bytes)
    print("Sent:", " ".join(f"{b:02X}" for b in command_bytes))
   # Read up to 4 bytes as a response (fixed-size response assumed)
    response = ser.read(4)  # Attendere 4 byte di risposta
    print("Received:", " ".join(f"{b:02X}" for b in response))
    #if len(response) < 9:
    #    print("Error: Received incomplete response")
    #else:
    #    print("Received:", " ".join(f"{b:02X}" for b in response))
    return response


def write_command(ser, address, data):
    # Constructs the write command as a byte sequence
    # The structure is:
    # [START_BYTE] + 4 bytes of address (big-endian) + 4 bytes of data (big-endian) + [END_BYTE]
    packet = [
        WRITE_CMD_START_BYTE,
        (address >> 24) & 0xFF, (address >> 16) & 0xFF, (address >> 8) & 0xFF, address & 0xFF,
        (data >> 24) & 0xFF, (data >> 16) & 0xFF, (data >> 8) & 0xFF, data & 0xFF,
        WRITE_CMD_END_BYTE
    ]
    return send_command(ser, bytes(packet))

def read_command(ser, address):
    # Constructs the read command:
    # [START_BYTE] + 4 bytes of address + [END_BYTE]
    packet = [
        READ_CMD_START_BYTE,
        (address >> 24) & 0xFF, (address >> 16) & 0xFF, (address >> 8) & 0xFF, address & 0xFF,
        READ_CMD_END_BYTE
    ]
    return send_command(ser, bytes(packet))

import csv


def process_csv_file(ser, filepath):
    # Reads a CSV file and writes each value to consecutive memory addresses
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
    # Launches the graphical user interface (GUI)
    def connect():
        # Opens the serial port
        try:
            port = port_entry.get()
            baud = int(baud_entry.get())
            ser = serial.Serial(port, baud, timeout=1)
            #messagebox.showinfo("Success", f"Connected to {port} at {baud} bps")
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
            response = write_command(ser, addr, data)
            if response:
                result_var.set(" ".join(f"{b:02X}" for b in response))
            else:
                result_var.set("No response")
        except ValueError:
            messagebox.showerror("Error", "Invalid hex format")
        ser.close()

    def send_read():
        ser = connect()
        if not ser: return
        try:
            addr = int(read_addr_entry.get(), 16)
            response = read_command(ser, addr)
            if response:
                result_var.set(" ".join(f"{b:02X}" for b in response))
            else:
                result_var.set("No response")
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

    tk.Label(root, text="Write Addr (hex):").grid(row=2, column=0)
    write_addr_entry = tk.Entry(root)
    write_addr_entry.grid(row=2, column=1)

    tk.Label(root, text="Write Data (hex):").grid(row=3, column=0)
    write_data_entry = tk.Entry(root)
    write_data_entry.grid(row=3, column=1)

    tk.Button(root, text="Send Write", command=send_write).grid(row=4, column=0, columnspan=2)

    tk.Label(root, text="Read Addr (hex):").grid(row=5, column=0)
    read_addr_entry = tk.Entry(root)
    read_addr_entry.grid(row=5, column=1)

    tk.Button(root, text="Send Read", command=send_read).grid(row=6, column=0, columnspan=2)

    tk.Label(root, text="Read Result:").grid(row=7, column=0)
    result_var = tk.StringVar()
    result_entry = tk.Entry(root, textvariable=result_var, state='readonly')
    result_entry.grid(row=7, column=1)

    tk.Button(root, text="Send File Commands", command=send_file).grid(row=8, column=0, columnspan=2, pady=10)

    root.mainloop()

if __name__ == "__main__":
    start_gui()
