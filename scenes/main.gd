extends Node

# Scene register
var scenes = {
    "game": preload("res://scenes/screens/game.tscn"),
    "game_over": preload("res://scenes/screens/game_over.tscn"),
    "round_win": preload("res://scenes/screens/round_win.tscn"),
    "main_menu": preload("res://scenes/screens/main_menu.tscn"),
    "credits": preload("res://scenes/screens/credits.tscn"),
    "help": preload("res://scenes/screens/help.tscn")
}

func _ready() -> void:
    print("Main: ready")
    $Music.play_rnd()
    set_active_scene("main_menu")

func set_active_scene(node: String) -> void:
    var next_scene = scenes[node].instantiate() as Screen
    next_scene.Main = self
    var cur_scene = $ActiveScene
    if len(cur_scene.get_children()) > 0:
        cur_scene.remove_child(cur_scene.get_children()[0])
    cur_scene.add_child(next_scene)
