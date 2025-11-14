from rich.progress import Progress, TaskID, TimeElapsedColumn, TimeRemainingColumn, BarColumn, TextColumn

class ProgressReporter:
    def __init__(self):
        # Configurazione esplicita per includere tutti i componenti (incluso il tempo)
        self.progress = Progress(
            TextColumn("[progress.description]{task.description}", justify="left"),
            BarColumn(),
            "[progress.percentage]{task.percentage:>3.0f}%",
            "•",
            TimeElapsedColumn(),  # Tempo trascorso
            "•",
            TimeRemainingColumn(), # Tempo rimanente (ETA)
            transient=True # Permette di rimuovere le barre completate
        )
        self.progress.start()
        self.tasks = {} # Mantenuto per compatibilità, ma useremo TaskID per l'update

    def create_task(self, name: str, total: int) -> TaskID:
        task_id = self.progress.add_task(name, total=total)
        # Salviamo l'ID, ma BatchRunner sarà incoraggiato ad usare direttamente l'ID
        self.tasks[name] = task_id 
        return task_id

    # --- METODO AGGIORNATO: Accetta TaskID direttamente ---
    def update(self, task_id: TaskID, advance: int = 1, description: str = None, total: int = None):
        """Aggiorna l'avanzamento del task e la sua descrizione, accettando TaskID."""
        # Aggiunta di un fallback robusto
        if isinstance(task_id, str):
            task_id = self.tasks.get(task_id)
            if task_id is None:
                # Se è l'ID stringa "Batch tasks" lo ricerchiamo, altrimenti errore
                raise ValueError(f"Task with name/ID '{task_id}' not found.")
        
        # rich.progress.update accetta TaskID, advance, description e total
        self.progress.update(task_id, advance=advance, description=description, total=total)

    def remove_task(self, task_id: TaskID):
        """Rimuove un task completato dalla visualizzazione."""
        self.progress.remove_task(task_id)
        
    def stop(self):
        self.progress.stop()