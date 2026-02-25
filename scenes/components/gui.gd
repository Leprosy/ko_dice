extends Control

var flash = preload("res://scenes/components/label_flash.tscn")
var info = preload("res://scenes/components/label_info.tscn")

func update(state: State) -> void:
    # Enabling buttons
    $Panel/Roll.disabled = not state.can_roll()
    $Panel/PlayHand.disabled = not state.can_play_hand()

    # Update labels
    $Panel/Round.text = "Round %s" % state.round
    $Panel/Hands.text = str(state.hands)
    $Panel/Rolls.text = str(state.rolls)
    $Panel/Score.text = "%s/%s" % [state.score, state.get_round_score()]

func display_flash(text: String, x: int, y: int, color:= Color(1,1,1,1)) -> void:
    var instance = flash.instantiate()
    self.add_child(instance)
    await instance.display(text, x, y, color)

func display_info(text: String, color := Color(1,1,1,1)) -> void:
    var instance = info.instantiate()
    self.add_child(instance)
    await instance.display(text, color)

func adding_points(add: int, mult: int, end: bool) -> void:
    if end:
        $Panel/AddScore.visible = false # TODO: fadeout?
        $Panel/AddScore/Add.text = "0"
        $Panel/AddScore/Mult.text = "1"
        return

    $Panel/AddScore.visible = true

    if add > 0:
        $Panel/AddScore/Add.text = str(add)
        $Panel/AddScore/Add/AnimationPlayer.play("pulse")
    if mult > 0:
        $Panel/AddScore/Mult.text = str(mult)
        $Panel/AddScore/Mult/AnimationPlayer.play("pulse")

func _on_roll_pressed() -> void:
    $"..".do_roll()

func _on_play_hand_pressed() -> void:
    $"..".do_play_hand()
