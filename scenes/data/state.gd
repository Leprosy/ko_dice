extends Node

class_name State

var round_score := 450
var rolls: int
var hands: int
var round := 0
var score: int
var perks: Array
var is_busy: bool

var hand_data = [
    {"id": "knockout", "name_key": "HAND_KNOCKOUT", "base": 48, "mult": 7, "played": 0, "level": 1 },
    {"id": "four_of_a_kind", "name_key": "HAND_FOUR_OF_A_KIND", "base": 24, "mult": 7, "played": 0, "level": 1 },
    {"id": "full_house", "name_key": "HAND_FULL_HOUSE", "base": 16, "mult": 4, "played": 0, "level": 1 },
    {"id": "three_of_a_kind", "name_key": "HAND_THREE_OF_A_KIND", "base": 12, "mult": 3, "played": 0, "level": 1 },
    {"id": "two_pairs", "name_key": "HAND_TWO_PAIRS", "base": 8, "mult": 2, "played": 0, "level": 1 },
    {"id": "pair", "name_key": "HAND_PAIR", "base": 4, "mult": 2, "played": 0, "level": 1 },
    {"id": "straight", "name_key": "HAND_STRAIGHT", "base": 12, "mult": 4, "played": 0, "level": 1 },
    {"id": "high_card", "name_key": "HAND_HIGH_CARD", "base": 8, "mult": 3, "played": 0, "level": 1 },
]

func _init():
    print("State: Ready")

func get_round_score():
    return round_score + (round - 1) * 250

# TODO: Add perk logic here instead of hardcoding
func get_available_hands() -> int:
    return 4

func get_available_rolls() -> int:
    return 2

func can_flip() -> bool:
    print(self.is_busy)
    print(self.rolls < self.get_available_rolls() - 1)
    return not self.is_busy and self.rolls < self.get_available_rolls() - 1

func can_select() -> bool:
    return not self.is_busy and self.rolls < self.get_available_rolls()

func can_roll() -> bool:
    return not self.is_busy and self.rolls > 0

func can_play_hand() -> bool:
    return not self.is_busy and self.rolls < self.get_available_rolls() and self.hands > 0

func play_hand() -> void:
    self.hands -= 1
    self.rolls = self.get_available_rolls()
    print("State: hand played", self.hands, self.rolls)

func reset_state(new_level = false) -> void:
    rolls = self.get_available_rolls()
    hands = self.get_available_hands()
    if new_level:
        round = round + 1
    else:
        perks = []
        round = 0
        for hand in hand_data:
            hand.played = 0
            hand.level = 1
    score = 0
    is_busy = false
    print("State: reset level %s" % round)

func increase_hand(hand_id: String):
    for hand in self.hand_data:
        if hand.id == hand_id:
            hand.played += 1

func calculate_roll(dice: Array):
    print("State: Got dice", dice)
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
