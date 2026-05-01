extends Node

class_name Signals

signal completed

var total := 0

func sumbit(sig: Signal) -> void:
    self.total += 1
    print("Signal: one added, total=", self.total, " ", sig.get_object_id())
    if not sig.is_connected(self._task_completed):
        sig.connect(self._task_completed)

func _task_completed() -> void:
    self.total = self.total - 1
    print("Signal: one completed, total=", self.total)
    if self.total == 0:
        print("Signals: queue completed")
        emit_signal("completed")
