extends Screen

var perk_scn = preload("res://scenes/components/perk.tscn")
var selected_perk = -1
const HOR_FIX = 100
const SCALE = 0.8

func _ready() -> void:
    var state = get_tree().root.get_node("Main/State")
    $AudioStreamPlayer.play()
    var available_perks = Perk.get_available_perks(state.perks)
    available_perks.shuffle()
    available_perks = available_perks.slice(0, 3)
    var i = 0
    for perk_name in available_perks:
        var perk_instance = perk_scn.instantiate()
        $Perks.add_child(perk_instance)
        perk_instance.get_perk(perk_name)
        var card = perk_instance.get_child(0)
        card.position.x = 10 + HOR_FIX * i
        card.position.y = 250
        perk_instance.perk_clicked.connect(on_perk_clicked.bind(perk_instance, i))
        unselect_card(card)
        i += 1

func _on_button_pressed() -> void:
    self.Main.set_active_scene("game")

func on_perk_clicked(perk_clicked, index):
    $Control/Panel/Help.visible = true
    if selected_perk == index:
        var anim = ($Perks.get_child(0).get_child(0).get_child(-1))
        anim.play("Select")
        await anim.animation_finished
        var state = get_tree().root.get_node("Main/State")
        var data = inst_to_dict(perk_clicked)
        state.perks.push_back(data)
        self.Main.set_active_scene("game")
    else:
        for perk in $Perks.get_children():
            unselect_card(perk.get_child(0))
        $Perks.move_child(perk_clicked, 0)
        select_card(perk_clicked.get_child(0))
        selected_perk = index

func select_card(card):
    card.z_index = 10
    card.scale.x = 1
    card.scale.y = 1

func unselect_card(card):
    card.z_index = 0
    card.scale.x = SCALE
    card.scale.y = SCALE
