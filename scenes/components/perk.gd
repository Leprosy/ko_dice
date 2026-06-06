class_name Perk

extends Panel

signal perk_clicked

var id: String
var description: String
var dice = []
var dice_plus: int
var dice_mult: int
var plus: int
var mult: int
var hand_type: String
var icon: String

# Icon register
var perk_icons = {
    "fwd": preload("res://assets/images/perks/fwd.png"),
    "plus": preload("res://assets/images/perks/plus.png"),
    "rem": preload("res://assets/images/perks/rem.png"),
    "undo": preload("res://assets/images/perks/undo.png"),
    "default": preload("res://assets/images/perks/default.png")
}

static var perks = [
    {
        "id": "plus",
        "plus": 10,
        "icon": "plus"
    },
    {
        "id": "mult",
        "mult": 4,
        "icon": "rem"
    },
    {
        "id": "first",
        "dice": [0],
        "dice_plus": 5,
        "icon": "undo"
    },
    {
        "id": "two_pair_plus",
        "plus": 15,
        "hand_type": "two_pair",
        "icon": "fwd"
    },
    {
        "id": "two_pair_mult",
        "mult": 6,
        "hand_type": "two_pair",
        "icon": "fwd"
    },
    {
        "id": "last",
        "dice": [4],
        "dice_plus": 5
    },
    {
        "id": "first_mult",
        "dice": [0],
        "dice_mult": 5
    }
]

static func name_key(perk_id: String) -> String:
    return "PERK_%s_NAME" % perk_id.to_upper()

static func desc_key(perk_id: String) -> String:
    return "PERK_%s_DESC" % perk_id.to_upper()

func _ready() -> void:
    print("Perk: ready")

static func get_available_perks(cur_perks):
    var cur_perk_ids = cur_perks.map(func(item): return item.id)
    var available_perks = perks.filter(func(item): return not cur_perk_ids.has(item.id))
    return available_perks.map(func(item): return item.id)

func get_perk(perk_id) -> void:
    print("Perk: get_perk")
    var perk = perks.filter(func(item): return item.id == perk_id)
    perk = perk[0]
    for key in perk:
        self[key] = perk[key]
    if not self.icon:
        self.icon = "default"
    $Name.text = tr(name_key(self.id))
    if not $Description == null:
        $Description.text = tr(desc_key(self.id))
    $Icon.texture = perk_icons[self.icon]

func to_dict() -> Dictionary:
    return {
        "id": id,
        "dice": dice,
        "dice_plus": dice_plus,
        "dice_mult": dice_mult,
        "plus": plus,
        "mult": mult,
        "hand_type": hand_type,
        "icon": icon
    }

func set_pos(x, y):
    position.x = x
    position.y = y

func _on_panel_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        emit_signal("perk_clicked")

func play_anim(anim_name: String) -> void:
    $AnimationPlayer.play(anim_name)
    await $AnimationPlayer.animation_finished
