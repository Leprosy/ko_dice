extends Control

var perk = preload("res://scenes/components/perk.tscn")

func _on_visibility_changed() -> void:
    if not self.visible:
        return
    var State = get_tree().root.get_node("Main/State")
    print(State.perks)
    print(self.visible) # Replace with function body.
    
    for perk_item in State.perks:
        print(perk_item)
        #var perk_instance = perk.instantiate()
        var item = Button.new()
        item.text = perk_item.perk_name
        $Panel/ScrollContainer/VBoxContainer.add_child(item)
        #perk_instance.get_perk(perk_item.perk_name)
