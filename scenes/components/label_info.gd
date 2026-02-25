extends Label

func display(txt: String, color: Color) -> void:
    self.text = txt
    self.add_theme_color_override("font_color", color)
    print("LabelInfo: label")
    $AnimationPlayer.play('fade')
    await $AnimationPlayer.animation_finished
    self.queue_free()
