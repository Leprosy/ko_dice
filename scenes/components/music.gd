extends AudioStreamPlayer

var bgs = [
    preload("res://assets/audio/music/bg1.mp3"),
    preload("res://assets/audio/music/bg2.mp3"),
    preload("res://assets/audio/music/bg3.mp3")
]

func _ready() -> void:
    #play_rnd()
    pass

func _on_finished() -> void:
    print("AudioStreamPlayer - Music: music end, switch tune")
    play_rnd()

func play_rnd() -> void:
    bgs.shuffle()
    print("AudioStreamPlayer - Music: playing %s" % bgs[0])
    stream = bgs[0]
    play()
