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

    def update(self, name: str, advance: int = 1):
        task_id = self.tasks[name]
        self.progress.update(task_id, advance=advance)

    def stop(self):
        self.progress.stop()
