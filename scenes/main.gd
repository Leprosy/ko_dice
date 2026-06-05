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
var user_data

func _ready() -> void:
    print("Main: ready")
    $Music.play_rnd()
    self.check_saved_data()
    self.set_active_scene("main_menu")

func set_active_scene(node: String) -> void:
    var next_scene = scenes[node].instantiate() as Screen
    next_scene.Main = self
    var cur_scene = $ActiveScene
    if len(cur_scene.get_children()) > 0:
        cur_scene.remove_child(cur_scene.get_children()[0])
    cur_scene.add_child(next_scene)

func check_saved_data() -> void:
    if not FileAccess.file_exists("user://user_data.save"):
        print("No saved data found, creating new savegame")
        self.user_data = {"max_round": 0}
        self.update_user_data()
    else:
        print("Saved data found, loading saved data")
        var file = FileAccess.open("user://user_data.save", FileAccess.READ)
        self.user_data = file.get_var()
        file.close()
    print(self.user_data)
    print("Data loaded")

func update_user_data() -> void:
    var file = FileAccess.open("user://user_data.save", FileAccess.WRITE)
    file.store_var(self.user_data)
    file.close()

func clear_saved_data() -> void:
    if FileAccess.file_exists("user://user_data.save"):
        var dir = DirAccess.open("user://")
        if dir:
            dir.remove("user_data.save")
    self.user_data = {"max_round": 0}
