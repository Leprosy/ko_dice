extends Control

const PERK_LIST := "TabContainer/Options/ScrollContainer/PerkGrid"
const HAND_TREE := "TabContainer/Status/HandTree"

var perk_scene = preload("res://scenes/components/mini_perk.tscn")

func _on_visibility_changed() -> void:
    if not self.visible:
        return

    var list = get_node(PERK_LIST)
    for child in list.get_children():
        child.free()
    var state = get_tree().root.get_node("Main/State")
    for perk_data in state.perks:
        var item = perk_scene.instantiate()
        item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        list.add_child(item)
        item.get_perk(perk_data.perk_name)

    var tree = get_node(HAND_TREE)
    tree.clear()
    tree.set_column_title(0, "Hand")
    tree.set_column_title(1, "Played")
    tree.set_column_title(2, "Lvl")
    for hand in state.hand_data:
        var item = tree.create_item()
        item.set_text(0, hand.name.replace("\n", " "))
        item.set_text(1, str(hand.played))
        item.set_text(2, str(hand.level))
        item.set_text_alignment(0, HORIZONTAL_ALIGNMENT_LEFT)
        item.set_text_alignment(1, HORIZONTAL_ALIGNMENT_CENTER)
        item.set_text_alignment(2, HORIZONTAL_ALIGNMENT_CENTER)

func _on_continue_pressed() -> void:
    self.visible = false

func _on_quit_pressed() -> void:
    $"../".Main.set_active_scene("game_over")
