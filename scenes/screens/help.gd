extends Screen

func _ready() -> void:
    $ScrollContainer/Body.text = tr("HELP_TEXT")

func on_back_pressed() -> void:
    self.Main.set_active_scene("main_menu")
