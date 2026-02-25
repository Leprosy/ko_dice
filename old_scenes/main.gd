extends Node

var scenes = {
    "game": preload("res://scenes/game.tscn"),
    "game_over": preload("res://scenes/game_over.tscn"),
    "round_win": preload("res://scenes/round_win.tscn"),
    "main_menu": preload("res://scenes/main_menu.tscn"),
    "credits": preload("res://scenes/credits.tscn")
}

func _ready() -> void:
    print("Main: ready")

func change_scene_to_node(cur_scene, node) -> void:
    var tree = get_tree()
    var next_scene = scenes[node].instantiate()
    self.add_child(next_scene)
    self.remove_child(cur_scene)
