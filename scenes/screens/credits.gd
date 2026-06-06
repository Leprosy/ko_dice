extends Screen

func _ready() -> void:
    $CenterContainer/Body.text = tr("CREDITS_TEXT")

func on_back_pressed() -> void:
    self.Main.set_active_scene("main_menu")
