extends Control

var perk = preload("res://scenes/components/perk.tscn")

func _on_visibility_changed() -> void:
    if not self.visible:
        return

    for child in $TabContainer/Options/ScrollContainer/VBoxContainer.get_children():
        child.queue_free()
    var state = get_tree().root.get_node("Main/State")
    for perk_item in state.perks:
        var item = Button.new()
        item.text = perk_item.perk_name
        $Panel/ScrollContainer/VBoxContainer.add_child(item)

    var hands = ""
    for hand in state.hand_data:
        hands += "\n%s   %d" % [hand.name.replace("\n", " "), hand.played]
    $TabContainer/Status/Label2.text = hands

func _on_continue_pressed() -> void:
    self.visible = false

func _on_quit_pressed() -> void:
    $"../".Main.set_active_scene("game_over")
