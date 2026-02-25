extends Label

func display(txt: String, x: int, y: int, color: Color) -> void:
    self.text = txt
    self.add_theme_color_override("font_color", color)
    var xpos = x - 150
    var ypos = y - 40

    if xpos > 180:
        xpos = 180
    if ypos > 550:
        ypos = 520

    self.position.x = xpos
    self.position.y = ypos
    print("LabelFlash: label at %s %s" % [x - 140, y - 80])
    $AnimationPlayer.play('show')
    await $AnimationPlayer.animation_finished
    self.queue_free()
