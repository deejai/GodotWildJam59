extends RigidBody3D

var jump_timer: float

var direction: float = 1.0
var direction_changed: bool = true

@onready var sprite: Sprite3D = $Sprite3D

func reset_jump_timer():
	jump_timer += randf_range(1.0, 3.0)

func _ready():
	reset_jump_timer()


func _process(delta):
	jump_timer -= delta
	if jump_timer <= 0.0:
		apply_central_impulse(Vector3(direction * randf_range(1.0, 3.0), randf_range(1.0, 2.5), 0.0))
		reset_jump_timer()

	if direction_changed:
		sprite.flip_h = direction > 0.0
		direction_changed = false

func kill():
	var bloody_mess =  Main.bloody_mess_scene.instantiate()
	bloody_mess.position = position
	get_parent().add_child(bloody_mess)
	queue_free()
