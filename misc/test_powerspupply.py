import tkinter as tk
import threading
import time
from tkinter import messagebox
from prova_classi.power_supply_controller import PowerSupplyService

def test_voltage_sequence():
    """Funzione di test collegata al bottone."""
    def worker():
        try:
            service = PowerSupplyService()
            service.connect(resource_index=0)
            channel = 1

            service.set_channel_current(channel, 0.1)
            service.output_on(channel)

            voltages = [0.6, 0.55, 0.5, 0.45, 0.4]
            for v in voltages:
                print(f"Imposto {v:.3f} V sul canale {channel}")
                service.set_channel_voltage(channel, v)
                measured = service.measure_voltage(channel)
                print(f"Tensione misurata: {measured:.3f} V")
                time.sleep(5)

            service.output_off(channel)
            service.close()
            messagebox.showinfo("Test completato", "Sequenza di test completata con successo!")

        except Exception as e:
            messagebox.showerror("Errore", f"Errore durante il test: {e}")

    # Esegui la sequenza in un thread separato per non bloccare la GUI
    threading.Thread(target=worker, daemon=True).start()

# --- Interfaccia grafica base ---
root = tk.Tk()
root.title("Power Supply Controller")

main_frame = tk.Frame(root, padx=20, pady=20)
main_frame.pack(fill="both", expand=True)

test_button = tk.Button(main_frame, text="Esegui Test Sequenza 0.6→0.4V", command=test_voltage_sequence)
test_button.pack(side="bottom", pady=10)

root.mainloop()
