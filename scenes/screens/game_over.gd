extends Screen

func _ready() -> void:
    self.Main.get_node("Music").stop()
    $AudioStreamPlayer.play()

func _on_button_pressed() -> void:
    self.Main.get_node("Music").play_rnd()
    self.Main.set_active_scene("main_menu")
