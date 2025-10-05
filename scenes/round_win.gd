extends Node

var perk = preload("res://scenes/perk.tscn")

func _ready() -> void:
    $AudioStreamPlayer.play()
    for i in range(0, 3):
        var perk_instance = perk.instantiate()
        self.add_child(perk_instance)
        perk_instance.set_pos(60, 250 + 140 * i)

func _on_button_pressed() -> void:
    self.get_parent().change_scene_to_node(self, "game")
