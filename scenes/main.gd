extends Node

const SUPPORTED_LOCALES := ["en", "es"]

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
var current_scene_key := ""

func _ready() -> void:
    print("Main: ready")
    $Music.play_rnd()
    self.check_saved_data()
    apply_locale(user_data["locale"], false)
    self.set_active_scene("main_menu")

func resolve_locale(raw: String) -> String:
    var lang := raw.split("_")[0].split("-")[0]
    return lang if lang in SUPPORTED_LOCALES else "en"

func apply_locale(locale: String, reload_scene := true) -> void:
    locale = resolve_locale(locale)
    user_data["locale"] = locale
    update_user_data()
    TranslationServer.set_locale(locale)
    if not reload_scene or current_scene_key == "":
        return
    if current_scene_key == "game":
        var scene = $ActiveScene.get_child(0)
        if scene.has_method("refresh_locale"):
            scene.refresh_locale()
        return
    set_active_scene(current_scene_key)

func set_active_scene(node: String) -> void:
    current_scene_key = node
    var next_scene = scenes[node].instantiate() as Screen
    next_scene.Main = self
    var cur_scene = $ActiveScene
    if len(cur_scene.get_children()) > 0:
        cur_scene.remove_child(cur_scene.get_children()[0])
    cur_scene.add_child(next_scene)

func check_saved_data() -> void:
    if not FileAccess.file_exists("user://user_data.save"):
        print("No saved data found, creating new savegame")
        self.user_data = {
            "max_round": 0,
            "locale": resolve_locale(OS.get_locale_language())
        }
        self.update_user_data()
    else:
        print("Saved data found, loading saved data")
        var file = FileAccess.open("user://user_data.save", FileAccess.READ)
        self.user_data = file.get_var()
        file.close()
        if not user_data.has("locale"):
            user_data["locale"] = resolve_locale(OS.get_locale_language())
    print(self.user_data)
    print("Data loaded")

func update_user_data() -> void:
    var file = FileAccess.open("user://user_data.save", FileAccess.WRITE)
    file.store_var(user_data)
    file.close()

func clear_saved_data() -> void:
    var locale = user_data.get("locale", resolve_locale(OS.get_locale_language()))
    if FileAccess.file_exists("user://user_data.save"):
        var dir = DirAccess.open("user://")
        if dir:
            dir.remove("user_data.save")
    self.user_data = {"max_round": 0, "locale": locale}
