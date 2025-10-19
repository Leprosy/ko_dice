extends Node

func _on_button_pressed() -> void:
    print("MainMenu: Start pressed")
    $"../State".reset_state(false)
    self.get_parent().change_scene_to_node(self, "game")

func _on_button__credits_pressed() -> void:
    print("MainMenu: Credits pressed")
    self.get_parent().change_scene_to_node(self, "credits")
