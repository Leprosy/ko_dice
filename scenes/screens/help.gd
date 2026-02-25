extends Screen

func _ready() -> void:
    print("Help: ready")

func on_back_pressed() -> void:
    self.Main.set_active_scene("main_menu")
