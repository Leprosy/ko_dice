extends Node

var die_scene = preload("res://scenes/die.tscn")
var dice = []
var State
var last_dblclick = false
var last_dieclicked = null

func _ready() -> void:    
    print("Game: ready")
    State = get_tree().root.get_node("Main/State")
    State.reset_state(true)
    $"Control - GUI".update_gui()
    dice = []
    var rng = RandomNumberGenerator.new()
    for i in range(0, 5):
        var new_die = die_scene.instantiate()
        new_die.position.x += rng.randf_range(-15, 15)
        new_die.position.z += rng.randf_range(-10, 10)
        dice.push_back(new_die)
        add_child(new_die)
        new_die.sleeping_state_changed.connect(_on_die_sleeping_state_changed)
        new_die.input_event.connect(create_cb(new_die))
    for perk in State.perks: # Perkd die emit particles
        for i in perk.dice:
            dice[i].emit(true)


func do_roll():
    State.dice_stopped = false
    $"Control - GUI".update_gui()
    print("Game: Rolling dice")
    $"AudioStreamPlayer - SFX".play_roll_sfx()
    for die in dice:
        die.roll()

func game_over():
    #do_roll()
    #self.get_parent().change_scene_to_node(self, "round_win")
    self.get_parent().change_scene_to_node(self, "game_over")

func round_win():
    self.get_parent().change_scene_to_node(self, "round_win")

func _on_die_sleeping_state_changed() -> void:
    if not State.dice_stopped:
        State.dice_stopped = dice.all(func (die): return round(die.linear_velocity.length()) == 0.0)
        if State.dice_stopped:
            var needs_reroll = false
            print("Game: Dice stopped %s" % State.dice_stopped)
            for die in dice:
                if die.needs_reroll():
                    print("Game: Die needs reroll %s" % die)
                    needs_reroll = true
                    die.nudge()
            if needs_reroll:
                State.dice_stopped = false
            else:
                print("Game: Dice are ok")
                $"Control - GUI".update_gui()

func play_roll():
    State.is_calculating = true
    $"Control - GUI".update_gui()
    var points = 0
    var data = State.calculate_roll(dice)
    var perks = State.perks
    await $"Control - GUI".display_info(data[0].name)
    await $"Control - GUI".display_info("+%s" % data[0].base)
    points += data[0].base

    for i in data[1]:
        dice[i].lift()
        var die_2d = get_viewport().get_camera_3d().unproject_position(dice[i].position)
        var value = dice[i].get_value()
        if value == 1:
            value = 10 #aces are 10s
        await $"Control - GUI".display_flash("+%s" % value, die_2d[0], die_2d[1])
        # Perks that mult/plus die
        print(i)
        print(perks)
        var die_perks = perks.filter(func(item): return item.dice.has(i))
        print(die_perks)
        for perk in die_perks:
            if perk.dice_plus:
                await $"Control - GUI".display_flash(perk.perk_name, die_2d[0], die_2d[1])
                await $"Control - GUI".display_flash("+%s" % perk.dice_plus, die_2d[0], die_2d[1])
                points += perk.dice_plus
            if perk.dice_mult:
                await $"Control - GUI".display_flash(perk.perk_name, die_2d[0], die_2d[1])
                await $"Control - GUI".display_flash("x%s" % perk.dice_mult, die_2d[0], die_2d[1])
                points *= perk.dice_mult
            #dice_mult
        #await $"Control - GUI".display_flash("OAW", die_2d[0], die_2d[1])
        points += value
        # await dice[i].ready

    await $"Control - GUI".display_info("x%s" % data[0].mult)
    points *= data[0].mult
    await $"Control - GUI".display_info("Total:\n%s" % points, true)
    for die in dice:
        if die.selected:
            die.select()
            die.no_flip = false 
    State.score += points
    State.is_calculating = false
    $"Control - GUI".update_gui()
    self.check_round()

func check_round():
    if State.score >= State.get_round_score():
        self.round_win()
    elif State.hands == 0:
        self.game_over()

func create_cb(die):
    return func(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
        if event is InputEventMouseButton:
            $Timer.start()
            last_dieclicked = die
            if event.double_click:
                last_dblclick = true

func _on_timer_timeout() -> void:
    print("Game: click done")
    if last_dblclick:
        last_dblclick = false
        if State.rolls > 0 or last_dieclicked.no_flip:
            $"AudioStreamPlayer - SFX".play_error_sfx()
        else:
            $"AudioStreamPlayer - SFX".play_flip_sfx()
            last_dieclicked.flip()
            await last_dieclicked.ready
            return
    else:
        print(last_dieclicked.rotation)
        print(last_dieclicked.get_value())
        if State.rolls > 1:
            $"AudioStreamPlayer - SFX".play_error_sfx()
        else:
            last_dieclicked.select()
