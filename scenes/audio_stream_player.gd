extends AudioStreamPlayer

var sfxs = [
    preload("res://assets/audio/sfx/roll1.mp3"),
    preload("res://assets/audio/sfx/error.mp3"),
    preload("res://assets/audio/sfx/flip.mp3"),
    preload("res://assets/audio/sfx/flash.mp3"),
    preload("res://assets/audio/sfx/info.mp3"),
    preload("res://assets/audio/sfx/end_info.mp3"),
]

func play_roll_sfx():
    self.stream = sfxs[0]
    self.play()

func play_error_sfx():
    self.stream = sfxs[1]
    self.play()
    
func play_flip_sfx():
    self.stream = sfxs[2]
    self.play()

func play_flash_sfx():
    self.stream = sfxs[3]
    self.play()

func play_info_sfx():
    self.stream = sfxs[4]
    self.play()

func play_end_info_sfx():
    self.stream = sfxs[5]
    self.play()
