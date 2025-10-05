extends RigidBody3D

const point = Vector3(0, 2.5, 0)
var selected = false
var no_flip = false

func _ready() -> void:
    add_user_signal("ready")
    var new_res = get_children()[1].mesh.duplicate(true)
    get_children()[1].mesh = new_res

func get_value() -> int:
    var rot = [
        (round(self.rotation[0])), 
        (round(self.rotation[1])),
        (round(self.rotation[2]))]
    if rot[0] == -2:
        return 1
    if abs(rot[0]) == 0 and abs(rot[2]) == 3:
        return 2
    if rot[0] == 0 and rot[2] == 2:
        return 3
    if rot[0] == 0 and rot[2] == -2:
        return 4
    if rot[0] == 0 and rot[2] == 0:
        return 5
    if rot[0] == 2:
        return 6
    return 666

func get_random_force():
    var rng = RandomNumberGenerator.new()
    const factor = 200.0
    var vect = Vector3(rng.randf_range(-1, 1), 0, rng.randf_range(-1, 1))
    vect.normalized()
    return vect * factor

func select() -> void:
    if selected:
        $MeshInstance3D.get_active_material(0).albedo_color = "#ffffff"
        set("freeze", false)
    else:
        $MeshInstance3D.get_active_material(0).albedo_color = "#ffaaaa"
        set("freeze", true)
    selected = not selected

func lift() -> void:
    var pos = Vector3(self.position.x, self.position.y, self.position.z)
    var tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
    tween.tween_property($".", "position", Vector3(self.position.x, self.position.y + 4, self.position.z), 0.35)
    tween.tween_property($".", "position", pos, 0.35)
    tween.tween_callback(func (): self.emit_signal("ready"))
    tween.play()

func flip() -> void:
    var pos = Vector3(self.position.x, self.position.y, self.position.z)
    var rot = Vector3(self.rotation.x, self.rotation.y, self.rotation.z)
    if get_value() == 1 or get_value() == 6:
        rot = Vector3(rot.x + PI, rot.y, rot.z)
    else:
         rot = Vector3(rot.x, rot.y, rot.z + PI)
    var tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
    tween.tween_property($".", "position", Vector3(self.position.x, self.position.y + 4, self.position.z), 0.25)
    tween.tween_property($".", "rotation", rot, 0.5)
    tween.tween_property($".", "position", pos, 0.25)
    tween.tween_callback(func (): self.emit_signal("ready"))
    tween.play()

func roll() -> void:
    if not selected:
        apply_impulse(get_random_force(), point)
    else:
        no_flip = true

func nudge() -> void:
    apply_impulse(get_random_force() * 0.3, point)

func needs_reroll():
    return self.get_value() == 666 or self.position.y > 2
