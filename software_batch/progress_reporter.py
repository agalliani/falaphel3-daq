# Nel file progress_reporter.py

from rich.progress import Progress, TaskID, TimeElapsedColumn, TimeRemainingColumn, BarColumn, TextColumn
# Importiamo le colonne per assicurarci che la temporizzazione sia configurata in modo esplicito (opzionale ma consigliato)

class ProgressReporter:
    def __init__(self):
        # Configurazione esplicita per includere tutti i componenti (incluso il tempo)
        self.progress = Progress(
            TextColumn("[progress.description]{task.description}", justify="left"),
            BarColumn(),
            "[progress.percentage]{task.percentage:>3.0f}%",
            "•",
            TimeElapsedColumn(),
            "•",
            TimeRemainingColumn(),
            # Opzionale: aggiungi una colonna per la velocità
            # "[progress.speed]{task.speed} it/s", 
            transient=True # Permette di rimuovere le barre completate automaticamente
        )
        self.progress.start()
        self.tasks = {}

    def create_task(self, name: str, total: int) -> TaskID:
        # Usiamo il nome come chiave, ma restituiamo l'ID di rich.TaskID
        task_id = self.progress.add_task(name, total=total)
        self.tasks[name] = task_id
        return task_id

    def update(self, name: str, advance: int = 1, description: str = None):
        """Aggiorna l'avanzamento del task e la sua descrizione."""
        # Se viene passato l'ID invece del nome, lo gestiamo
        if isinstance(name, TaskID):
            task_id = name
        else:
            task_id = self.tasks[name]
        
        # Passa advance E description al metodo update di rich
        self.progress.update(task_id, advance=advance, description=description)

    def remove_task(self, task_id: TaskID):
        """Rimuove un task completato dalla visualizzazione."""
        try:
            # La logica è basata sulla rimozione dall'interfaccia rich
            self.progress.remove_task(task_id)
            # Rimuovi anche da self.tasks se vuoi tenere pulito, ma è più complesso se usi il nome/ID in modo promiscuo
        except KeyError:
            pass # Task non trovato
        
    def stop(self):
        self.progress.stop()