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

static var perks = [
    {
        "perk_name": "Plus",
        "description": "Adds 10 points to the hand played",
        "dice_plus": 10
    },
    {
        "perk_name": "Mult",
        "description": "Adds 4 mult to the hand played",
        "dice_mult": 4
    },
    {
        "perk_name": "First",
        "description": "First die has 5 extra points",
        "dice": [0],
        "dice_plus": 5
    },
    {
        "perk_name": "Two Pair Plus",
        "description": "Adds 15 points if hand is 2 Pair",
        "dice_plus": 15,
        "hand_type": "Two Pair"
    },
    {
        "perk_name": "Two Pair Mult",
        "description": "Adds 6 mult if the hand is 2 Pair",
        "dice_mult": 6,
        "hand_type": "Two Pair"
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
        "dice_plus": 5
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
    $"Panel - PerkCard/Label - Name".text = self.perk_name
    $"Panel - PerkCard/Label - Desc".text = self.description

func set_pos(x, y):
    $"Panel - PerkCard".position.x = x
    $"Panel - PerkCard".position.y = y

func _on_panel__perk_card_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and not event.is_pressed():
        self.get_parent().on_perk_clicked(self)
