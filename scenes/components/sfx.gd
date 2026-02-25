extends AudioStreamPlayer

var sfxs := {
    "roll": preload("res://assets/audio/sfx/roll1.mp3"),
    "error": preload("res://assets/audio/sfx/error.mp3"),
    "flip": preload("res://assets/audio/sfx/flip.mp3"),
    "flash": preload("res://assets/audio/sfx/flash.mp3"),
    "info": preload("res://assets/audio/sfx/info.mp3"),
    "end_info": preload("res://assets/audio/sfx/end_info.mp3"),
}

func play_sfx(key: String) -> void:
    self.stream = sfxs[key]
    self.play()
