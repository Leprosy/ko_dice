extends Screen

var die_scene = preload("res://scenes/components/die.tscn")
var perk_scn = preload("res://scenes/components/perk.tscn")
var dice = []
var state: State
var is_playing_hand := false
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
        new_die.connect("die_update", self.on_die_update)
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
    print("\nGame: Rolling dice")
    $SFX.play_sfx("roll")
    for die in dice:
        if not die.selected:
            die.roll()
        else:
            die.cant_flip = true

func do_play_hand() -> void:
    self.is_playing_hand = true
    for die in dice:
        die.cant_flip = false
    state.is_busy = true
    state.play_hand()
    $GUI.update(state)
    print("Game: Playing hand")
    await self.display_hand_results()
    state.is_busy = false
    $GUI.update(state)
    self.check_round_results()
    self.is_playing_hand = false
    
func do_toggle_control_panel() -> void:
    $ControlPanel.visible = not $ControlPanel.visible

func on_die_click(die):
    if not state.can_select():
        $SFX.play_sfx("error")
        return
    die.select()

func on_die_dblclick(die):
    if not state.can_flip() or die.cant_flip:
        $SFX.play_sfx("error")
        return
    $SFX.play_sfx("flip")
    die.flip()
    
func on_die_update():
    if self.is_playing_hand:
        return
    var all_stopped = self.dice.all(func(die): return not die.is_moving)
    state.is_busy = not all_stopped
    if (all_stopped):
        print("Game: Dice stopped")
    $GUI.update(state)    



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
    state.increase_hand(data[0].name)

    # dice bonus
    for i in data[1]:
        await dice[i].lift()
        var die_2d = get_viewport().get_camera_3d().unproject_position(dice[i].position)
        var value = dice[i].get_value()
        if value == 1:
            value = 10 #aces are 10s
        plus += value
        $SFX.play_sfx("flash")
        await $GUI.adding_points(plus, 0, false)
        await $GUI.display_flash("+%s" % value, die_2d[0], die_2d[1], Color.DEEP_SKY_BLUE)

        # Perks that mult/plus die
        var die_perks = perks.filter(func(item): return item.dice.has(i))
        for perk in die_perks:
            if perk.dice_plus:
                $SFX.play_sfx("flash")
                plus += perk.dice_plus
                await self.flash_perk(perk.perk_name)
                await $GUI.adding_points(plus, 0, false)
                await $GUI.display_flash("+%s" % perk.dice_plus, die_2d[0], die_2d[1], Color.DODGER_BLUE)
            if perk.dice_mult:
                $SFX.play_sfx("flash")
                mult += perk.dice_mult
                await self.flash_perk(perk.perk_name)
                await $GUI.adding_points(0, mult, false)
                await $GUI.display_flash("+%sX" % perk.dice_mult, die_2d[0], die_2d[1], Color.ORANGE)
    
    # extra perk points
    for perk in perks:
        if perk.plus:
            $SFX.play_sfx("info")
            plus += perk.plus
            await self.flash_perk(perk.perk_name)
            await $GUI.adding_points(plus, 0, false)
            await $GUI.display_info("+%s" % perk.plus)

    # Base mult
    mult += data[0].mult
    $SFX.play_sfx("info")
    await $GUI.adding_points(0, mult, false)
    await $GUI.display_info("+%sX" % data[0].mult, Color.ORANGE)

    # Extra perk mult
    for perk in perks:
        if perk.mult:
            mult += perk.mult
            $SFX.play_sfx("info")
            await self.flash_perk(perk.perk_name)
            await $GUI.adding_points(0, mult, false)
            $SFX.play_sfx("info")
            await $GUI.display_info("+%sX" % perk.mult, Color.ORANGE)

    # Total
    var points = plus * mult
    $SFX.play_sfx("end_info")
    await $GUI.display_info("Total\n%s" % points, Color.DODGER_BLUE)
    await $GUI.adding_points(0, 0, true)
    for die in dice:
        if die.selected:
            die.select()
    state.score += points

func flash_perk(perk_name: String) -> void:
    var prk = perk_scn.instantiate()
    self.add_child(prk)
    prk.get_perk(perk_name)
    prk.set_pos(100,200) # TODO: Improve positioning
    await prk.play_anim("Flash")
    prk.queue_free()
