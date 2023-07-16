extends CharacterBody3D

class_name Player

const SPEED = 1.3
const JUMP_VELOCITY = 2.5

var look_dir: float = 1.0
var has_moved: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const MAX_COYOTE_TIME: float = 0.1
var coyote_timer: float = 0.0
var airborne: bool = true

func _ready():
	Main.player = self

func _physics_process(delta):
	if airborne and is_on_floor():
		airborne = false
		coyote_timer = 0.0
	if not is_on_floor():
		velocity.y -= gravity * delta

		if not airborne:
			coyote_timer += delta
			if coyote_timer > MAX_COYOTE_TIME:
				airborne = true

	if Input.is_action_just_pressed("ui_accept"):
		print(coyote_timer)
		if not airborne:
			velocity.y = JUMP_VELOCITY
			airborne = true

	var direction = Input.get_axis("Move Left", "Move Right")
	if abs(direction) > 0.0:
		has_moved = true
		look_dir = signf(direction)
		velocity.x = direction * SPEED
		Main.last_known_player_position = global_position
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func kill():
	var bloody_mess =  Main.bloody_mess_scene.instantiate()
	bloody_mess.position = position
	get_parent().add_child(bloody_mess)
	queue_free()
