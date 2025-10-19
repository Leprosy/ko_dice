extends Control

var flash = preload("res://scenes/label_flash.tscn")
var State

func _ready():
    State = get_tree().root.get_node("Main/State")

func _on_button__roll_pressed() -> void:
    State.rolls -= 1
    update_gui()
    var Game = self.get_parent()
    print("GUI: Roll pressed")
    Game.do_roll()

func _on_button__die_pressed() -> void:
    var Game = self.get_parent()
    print("GUI: Die pressed")
    Game.game_over()

func _on_button__play_pressed() -> void:
    State.hands -= 1
    State.rolls = 2
    update_gui()
    var Game = self.get_parent()
    Game.play_roll()
    print("GUI: Play pressed")

func display_flash(text, x, y):
    var instance = flash.instantiate()
    self.add_child(instance)
    $"../AudioStreamPlayer - SFX".play_flash_sfx()
    instance.display_flash(text, x, y)
    await instance.get_children()[0].animation_finished
    instance.queue_free()

func display_info(text, end = false):
    $"Label - Info".text = text
    $"Label - Info/AnimationPlayer".play("fade")
    if end:
        $"../AudioStreamPlayer - SFX".play_end_info_sfx()
    else:
        $"../AudioStreamPlayer - SFX".play_info_sfx()
    await $"Label - Info/AnimationPlayer".animation_finished
    return

func update_pre_score(plus, mult):
    if plus == 0 and mult == 0:
        $Node2D/LabelPlus.text = ''
        $Node2D/LabelMult.text = ''
    else:
        $Node2D/LabelPlus.text = "+ %s" % plus
        $Node2D/LabelMult.text = "x %s" % mult

func update_gui() -> void:
    $"Panel/Button - Roll".disabled = State.rolls <= 0 \
        or State.dice_stopped == false or State.is_calculating
    $"Panel/Button - Play".disabled = State.hands <= 0 \
        or State.dice_stopped == false \
        or State.rolls >= 2
    $"Panel/Label - Round".text = "Round %s" % State.round
    $"Panel/Label - Hand".text = "%s" % State.hands
    $"Panel/Label - Roll".text = "%s" % State.rolls
    $"Panel/Label - Score".text = "%s/%s" % [State.score, State.get_round_score()]
