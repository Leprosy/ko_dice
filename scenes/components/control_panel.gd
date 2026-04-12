extends Control

var perk = preload("res://scenes/components/perk.tscn")

func _on_visibility_changed() -> void:
    if not self.visible:
        return
    var State = get_tree().root.get_node("Main/State")
    print(State.perks)
    print(self.visible) # Replace with function body.
    
    var i = 0
    for perk_item in State.perks:
        print(perk_item)
        var perk_instance = perk.instantiate()
        $Panel/ScrollContainer.add_child(perk_instance)
        perk_instance.get_perk(perk_item.perk_name)
        perk_instance.set_pos(60, 250 + 140 * i)
        i += 1
