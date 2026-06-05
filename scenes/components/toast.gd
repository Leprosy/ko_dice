extends PanelContainer

var _tween: Tween

func show_message(text: String, duration: float = 2.0) -> void:
    if _tween:
        _tween.kill()
    $Label.text = text
    modulate.a = 0.0
    visible = true
    _tween = create_tween()
    _tween.tween_property(self, "modulate:a", 1.0, 0.2)
    _tween.tween_interval(duration)
    _tween.tween_property(self, "modulate:a", 0.0, 0.3)
    await _tween.finished
    _tween = null
    visible = false
