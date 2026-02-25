extends Screen

var perk = preload("res://scenes/components/perk.tscn")

func _ready() -> void:
    var State = get_tree().root.get_node("Main/State")
    $AudioStreamPlayer.play()
    var available_perks = Perk.get_available_perks(State.perks)
    available_perks.shuffle()
    available_perks = available_perks.slice(0, 3)
    var i = 0
    for perk_name in available_perks:
        var perk_instance = perk.instantiate()
        self.add_child(perk_instance)
        perk_instance.get_perk(perk_name)
        perk_instance.set_pos(60, 250 + 140 * i)
        i += 1

func _on_button_pressed() -> void:
    self.Main.set_active_scene("game")

func on_perk_clicked(perk):
    var State = get_tree().root.get_node("Main/State")
    var data = inst_to_dict(perk)
    State.perks.push_back(data)
    self.Main.set_active_scene("game")
