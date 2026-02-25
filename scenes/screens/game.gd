extends Screen

var die_scene = preload("res://scenes/components/die.tscn")
var dice = []
var state: State
const mid_x = 192
const mid_y = 400

func _ready() -> void:
    print("Game: ready")
    state = $"../../State"
    state.reset_state(true)
    $GUI.update(state)
    dice = []
    var rng = RandomNumberGenerator.new()

    for i in range(0, 5):
        var new_die = die_scene.instantiate()
        new_die.connect("die_clicked", self.on_die_click)
        new_die.connect("die_dblclicked", self.on_die_dblclick)
        new_die.id = i
        new_die.position.x += rng.randf_range(-15, 15)
        new_die.position.z += rng.randf_range(-10, 10)
        dice.push_back(new_die)
        add_child(new_die)
    for perk in state.perks: # Perkd die emit particles
        for i in perk.dice:
            dice[i].emit(true)

func check_round_results():
    if state.score >= state.get_round_score():
        print("Game: round_win")
        self.Main.set_active_scene("round_win")
    elif state.hands == 0:
        print("Game: game_over")
        self.Main.set_active_scene("game_over")

func do_roll() -> void:
    state.is_busy = true
    state.rolls = state.rolls - 1
    $GUI.update(state)
    print("Game: Rolling dice")
    $SFX.play_sfx("roll")
    var signals = []
    for die in dice:
        if not die.selected:
            die.roll()
            signals.push_back(die.die_stopped)
    $Signals.sumbit(signals)
    await $Signals.completed # TODO: Check all die are stopped

    print("Game: Rolling complete")
    state.is_busy = false
    $GUI.update(state)

func do_play_hand() -> void:
    state.is_busy = true
    state.play_hand()
    $GUI.update(state)
    print("Game: Playing hand")
    await self.display_hand_results()
    state.is_busy = false
    $GUI.update(state)
    self.check_round_results()

func on_die_click(die):
    if not state.can_select():
        $SFX.play_sfx("error")
        return
    die.select()
    print("ODC: OAW", die)

func on_die_dblclick(die):
    if not state.can_flip():
        $SFX.play_sfx("error")
        return
    print("ODDC: OAW", die)
    $SFX.play_sfx("flip")
    die.flip()


# Big one here
func display_hand_results() -> void:
    var plus = 0
    var mult = 1
    var data = state.calculate_roll(self.dice)
    var perks = state.perks

    # base plus
    plus += data[0].base
    $SFX.play_sfx("info")
    await $GUI.adding_points(plus, 0, false)
    await $GUI.display_info(data[0].name)

    # dice plus
    for i in data[1]:
        dice[i].lift()
        var die_2d = get_viewport().get_camera_3d().unproject_position(dice[i].position)
        var value = dice[i].get_value()
        if value == 1:
            value = 10 #aces are 10s
        plus += value
        $SFX.play_sfx("flash")
        await $GUI.adding_points(plus, 0, false)
        await $GUI.display_flash("+%s" % value, die_2d[0], die_2d[1])

        # Perks that mult/plus die
        var die_perks = perks.filter(func(item): return item.dice.has(i))
        for perk in die_perks:
            if perk.dice_plus:
                $SFX.play_sfx("flash")
                plus += perk.dice_plus
                $GUI.display_flash("Perk", die_2d[0], die_2d[1] - 50, Color.CORNFLOWER_BLUE)
                await $GUI.display_flash(perk.perk_name, die_2d[0], die_2d[1])
                await $GUI.adding_points(plus, 0, false)
                await $GUI.display_flash("+%s" % perk.dice_plus, die_2d[0], die_2d[1], Color.DODGER_BLUE)
            if perk.dice_mult:
                $SFX.play_sfx("flash")
                mult += perk.dice_mult
                $GUI.display_flash("Perk", die_2d[0], die_2d[1] - 50, Color.CORNFLOWER_BLUE)
                await $GUI.display_flash(perk.perk_name, die_2d[0], die_2d[1])
                await $GUI.adding_points(0, mult, false)
                await $GUI.display_flash("+%s" % perk.dice_mult, die_2d[0], die_2d[1], Color.ORANGE)
    
    # extra perk points
    for perk in perks:
        if perk.plus:
            $SFX.play_sfx("info")
            plus += perk.plus
            $GUI.display_flash("Perk", mid_x, mid_y, Color.CORNFLOWER_BLUE)
            await $GUI.display_info("%s" % perk.perk_name)
            await $GUI.adding_points(plus, 0, false)
            await $GUI.display_info("+%s" % perk.plus)

    # Base mult
    mult += data[0].mult
    $SFX.play_sfx("info")
    await $GUI.adding_points(0, mult, false)
    await $GUI.display_info("+ %sX" % data[0].mult, Color.ORANGE)

    # Extra perk mult
    for perk in perks:
        if perk.mult:
            mult += perk.mult
            $SFX.play_sfx("info")
            $GUI.display_flash("Perk", mid_x, mid_y, Color.CORNFLOWER_BLUE)
            await $GUI.display_info("%s" % perk.perk_name)
            await $GUI.adding_points(0, mult, false)
            $SFX.play_sfx("info")
            await $GUI.display_info("+ %sX" % perk.mult)

    # Total
    var points = plus * mult
    $SFX.play_sfx("end_info")
    await $GUI.display_info("Total\n%s" % points, Color.DODGER_BLUE)
    await $GUI.adding_points(0, 0, true)
    for die in dice:
        if die.selected:
            die.select()
            die.no_flip = false 
    state.score += points
