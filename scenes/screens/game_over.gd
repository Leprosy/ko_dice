extends Screen

func _ready() -> void:
    var state = $"../../State"
    var user_data = self.Main.user_data
    print(user_data)
    self.Main.get_node("Music").stop()

    if state.round > user_data.max_round:
        $Control/Panel/RecordLabel.visible = true
        user_data.max_round = state.round
        self.Main.update_user_data()
    else:
        $Control/Panel/RecordLabel.visible = false

    $Control/Panel/Label.text = tr("You reached round %s") % state.round
    $AudioStreamPlayer.play()
    state.reset_state(false)

func _on_button_pressed() -> void:
    self.Main.get_node("Music").play_rnd()
    self.Main.set_active_scene("main_menu")
