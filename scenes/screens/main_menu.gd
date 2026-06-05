extends Screen

func _ready() -> void:
    print("MainMenu: ready")
    $Label/AnimationPlayer.play('pulse')

func on_new_run_press() -> void:
    self.Main.set_active_scene("round_win")

func on_credit_press() -> void:
    self.Main.set_active_scene("credits")

func on_help_pressed() -> void:
    self.Main.set_active_scene("help")

func on_clear_saved_data_press() -> void:
    self.Main.clear_saved_data()
    $Toast.show_message("Saved data cleared")
