from rich.progress import Progress, TaskID

class ProgressReporter:
    def __init__(self):
        self.progress = Progress()
        self.progress.start()
        self.tasks = {}

    def create_task(self, name: str, total: int) -> TaskID:
        task_id = self.progress.add_task(name, total=total)
        self.tasks[name] = task_id
        return task_id

    # --- MODIFICA QUI ---
    def update(self, name: str, advance: int = 1, description: str = None):
        """Aggiorna l'avanzamento del task e la sua descrizione."""
        task_id = self.tasks[name]
        
        # Passa advance E description al metodo update di rich
        self.progress.update(task_id, advance=advance, description=description)

    def stop(self):
        self.progress.stop()