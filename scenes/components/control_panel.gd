extends Control

var perk = preload("res://scenes/components/perk.tscn")

func _on_visibility_changed() -> void:
    if not self.visible:
        return

    for child in $Panel/ScrollContainer/VBoxContainer.get_children():
        child.queue_free()
    var State = get_tree().root.get_node("Main/State")    
    for perk_item in State.perks:
        var item = Button.new()
        item.text = perk_item.perk_name
        $Panel/ScrollContainer/VBoxContainer.add_child(item)

func _on_continue_pressed() -> void:
    self.visible = false

func _on_quit_pressed() -> void:
    $"../".Main.set_active_scene("game_over")
