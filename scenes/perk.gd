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
        "description": "First die has 5 points",
        "dice": [0],
        "dice_plus": 5
    }
]

func _ready() -> void:
    print("Perk: created")
    var perk = perks.pick_random()
    for key in perk:
        self[key] = perk[key]
    $"Panel - PerkCard/Label - Name".text = self.perk_name
    $"Panel - PerkCard/Label - Desc".text = self.description

func set_pos(x, y):
    $"Panel - PerkCard".position.x = x
    $"Panel - PerkCard".position.y = y

func _on_panel__perk_card_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        print(self.dice)
        print(event)
