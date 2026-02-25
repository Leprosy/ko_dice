extends Node

class_name Signals

signal completed

var total := 0

func sumbit(signals: Array) -> void:
    self.total = len(signals)
    for sig: Signal in signals:
        if not sig.is_connected(self._task_completed):
            sig.connect(self._task_completed)

func _task_completed() -> void:
    self.total = self.total - 1
    if self.total == 0:
        emit_signal("completed")
