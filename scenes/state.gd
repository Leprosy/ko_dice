extends Node

var round_score = 350
var rolls: int
var hands: int
var round = 0
var score: int
var dice_stopped: bool
var is_calculating: bool
var perks: Array

var hand_data = [
    {"name": "Knockout!", "base": 48, "mult": 7 },
    {"name": "4 of\na kind", "base": 24, "mult": 7 },   
    {"name": "Full\nhouse", "base": 16, "mult": 4 },   
    {"name": "Three of\na kind", "base": 12, "mult": 3 },   
    {"name": "Two\npairs", "base": 8, "mult": 2 },   
    {"name": "Pair", "base": 4, "mult": 2 },
    {"name": "Straight", "base": 12, "mult": 4 },
    {"name": "???", "base": 8, "mult": 3 }, 
]

func _init():
    print("State: Ready")

func get_round_score():
    return round_score + (round - 1) * 150

func reset_state(new_level = false) -> void:
    rolls = 2
    hands = 4
    if new_level:
        round = round + 1
    else:
        perks = []
        round = 0
    score = 0
    dice_stopped = false
    is_calculating = false
    print("State: reset level %s" % round)

func calculate_roll(dice: Array):
    print("State: got dice")
    var info = ''
    var used_dice = []
    var data = [[], [], [], [], [], []]
    for i in len(dice):
        var die = dice[i]
        var val = die.get_value() - 1
        data[val].push_back(i)
    data = range(0, 6).map(func(i): return {"rank": i + 1, "dice": data[i]})
    data = data.filter(func(item): return len(item.dice) > 0)
    data.sort_custom(func(a,b): 
        if len(a.dice) != len(b.dice):
            return len(a.dice) > len(b.dice)
        else:
            return a.rank > b.rank
    )

    #Get hand
    if len(data[0].dice) == 5:
        info = hand_data[0]
        used_dice = data[0].dice
    elif len(data[0].dice) == 4:
        info = hand_data[1]
        used_dice = data[0].dice
    elif len(data[0].dice) == 3:
        if len(data[1].dice) == 2:
            info = hand_data[2]
            used_dice = data[0].dice + data[1].dice
        else:
            info = hand_data[3]
            used_dice = data[0].dice
    elif len(data[0].dice) == 2:
        if len(data[1].dice) == 2:
            info = hand_data[4]
            used_dice = data[0].dice + data[1].dice
        else:
            info = hand_data[5]
            used_dice = data[0].dice

    elif data[0].rank == 6 and data[4].rank == 1:
        used_dice = [0, 1, 2, 3, 4]
        info = hand_data[7]
    else:
        used_dice = [0, 1, 2, 3, 4]
        info = hand_data[6]

    return [info, used_dice]
