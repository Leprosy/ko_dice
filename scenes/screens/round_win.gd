extends Screen

var perk = preload("res://scenes/components/perk.tscn")
var selected_perk = -1
const PERK_ANGLE = PI/14
const HOR_FIX = 70
const VERT_FIX = 10

func _ready() -> void:
    var state = get_tree().root.get_node("Main/State")
    $AudioStreamPlayer.play()
    var available_perks = Perk.get_available_perks(state.perks)
    available_perks.shuffle()
    available_perks = available_perks.slice(0, 3)
    var i = 0
    for perk_name in available_perks:
        var perk_instance = perk.instantiate()
        $Perks.add_child(perk_instance)
        perk_instance.get_perk(perk_name)
        perk_instance.set_pos(40 + HOR_FIX * i, 250 + VERT_FIX * i)
        perk_instance.get_child(0).set_rotation(-PERK_ANGLE + PERK_ANGLE * i)
        perk_instance.perk_clicked.connect(on_perk_clicked.bind(perk_instance, i))
        i += 1

func _on_button_pressed() -> void:
    self.Main.set_active_scene("game")

func on_perk_clicked(perk_clicked, index):
    var i = 0
    for perk in $Perks.get_children():
        perk.get_child(0).z_index = 0
        perk.get_child(0).set_rotation(-PERK_ANGLE + PERK_ANGLE * i)
        perk.set_pos(40 + HOR_FIX * i, 250 + VERT_FIX * i)
        i+=1
    
    if selected_perk == index:
        var state = get_tree().root.get_node("Main/State")
        var data = inst_to_dict(perk_clicked)
        state.perks.push_back(data)
        self.Main.set_active_scene("game")
    else:
        var old_pos = perk_clicked.get_child(0).position
        print(old_pos)
        var card = perk_clicked.get_child(0)
        card.z_index = 10
        card.set_rotation(0)
        perk_clicked.set_pos(old_pos.x, old_pos.y - 60)
        selected_perk = index
