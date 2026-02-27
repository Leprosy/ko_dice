class_name Perk

extends Node

var perk_name: String
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
        "perk_name": "Plus",
        "description": "Adds 10 points to the hand played",
        "plus": 10,
        "icon": "plus"
    },
    {
        "perk_name": "Mult",
        "description": "Adds 4 mult to the hand played",
        "mult": 4,
        "icon": "rem"
    },
    {
        "perk_name": "First",
        "description": "First die has 5 extra points",
        "dice": [0],
        "dice_plus": 5,
        "icon": "undo"
    },
    {
        "perk_name": "Two Pair Plus",
        "description": "Adds 15 points if hand is 2 Pair",
        "plus": 15,
        "hand_type": "Two Pair",
        "icon": "fwd"
    },
    {
        "perk_name": "Two Pair Mult",
        "description": "Adds 6 mult if the hand is 2 Pair",
        "mult": 6,
        "hand_type": "Two Pair",
        "icon": "fwd"
    },
    {
        "perk_name": "Last",
        "description": "Last die has 5 extra points",
        "dice": [4],
        "dice_plus": 5
    },
    {
        "perk_name": "First Mult",
        "description": "Adds 5 mult to the first die",
        "dice": [0],
        "dice_mult": 5
    }
]

func _ready() -> void:
    print("Perk: ready")

static func get_available_perks(cur_perks):
    var cur_perk_names = cur_perks.map(func(item): return item.perk_name)
    var available_perks = perks.filter(func(item): return not cur_perk_names.has(item.perk_name))
    return available_perks.map(func(item): return item.perk_name)

func get_perk(perk_name) -> void:
    print("Perk: get_perk")
    print(perk_name)
    var perk = perks.filter(func(item): return item.perk_name == perk_name)
    perk = perk[0]
    for key in perk:
        self[key] = perk[key]
    if not self.icon:
        self.icon = "default"
    $Panel/Name.text = self.perk_name
    $Panel/Description.text = self.description
    $Panel/Icon.texture = perk_icons[self.icon]

func set_pos(x, y):
    $Panel.position.x = x
    $Panel.position.y = y

func _on_panel__perk_card_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and not event.is_pressed():
        self.get_parent().on_perk_clicked(self)
