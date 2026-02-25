extends Screen

func _ready() -> void:
    print("MainMenu: ready")

func on_new_run_press() -> void:
    self.Main.set_active_scene("game")

func on_credit_press() -> void:
    self.Main.set_active_scene("credits")

func on_help_pressed() -> void:
    self.Main.set_active_scene("help")
