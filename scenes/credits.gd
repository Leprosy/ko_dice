extends Node

func _ready() -> void:
    #self.get_parent().get_node("AudioStreamPlayer - Music").stop()
    $AudioStreamPlayer.play()

func _on_button_pressed() -> void:
    #self.get_parent().get_node("AudioStreamPlayer - Music").play_rnd()
    self.get_parent().change_scene_to_node(self, "main_menu")
