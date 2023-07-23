extends CharacterBody3D

class_name Player

const SPEED = 1.4
const JUMP_VELOCITY = 2.5

var look_dir: float = 1.0
var has_moved: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const MAX_COYOTE_TIME: float = 0.15
var coyote_timer: float = 0.0
var airborne: bool = true

var can_shoot: bool = false

@onready var sprite_bagempty: Sprite3D = $Sprite_BagEmpty
@onready var sprite_bagfull: Sprite3D = $Sprite_BagFull

@onready var gunshot_sprite: Sprite3D = $GunshotSprite
@onready var show_gunshot_timer: Timer = $ShowGunshotTimer
@onready var shoot_cd_timer: Timer = $ShootCDTimer
@onready var gun_player: AudioStreamPlayer3D = $GunPlayer
var gunshot_sprite_origin: Vector3

var gun_targets: Array = []

@onready var action_prompt_meshinstance: MeshInstance3D = $Node/ActionPrompt
var action_prompt_meshinstance_origin: Vector3 = Vector3(0.0, 0.5, 0.03)

var has_coal: bool = false

var action_prompts = []

var time_passed: float = randf()

var push_cd: float = 0.0
var push_x: float = 0.0

var y_offset: float = .369

func _ready():
	Main.player = self
	gunshot_sprite_origin = gunshot_sprite.position
	update_direction_dependencies()

func _physics_process(delta):
	time_passed += delta

	push_cd = max(0.0, push_cd - delta)

	action_prompt_meshinstance.position = global_position + action_prompt_meshinstance_origin + Vector3.UP * 0.02 * (sin(time_passed))
	action_prompt_meshinstance.rotation.z = sin(4.0 * time_passed) * 0.035

	if airborne and is_on_floor():
		airborne = false
		coyote_timer = 0.0

	if not is_on_floor():
		velocity.y -= gravity * delta

		if not airborne:
			coyote_timer += delta
			if coyote_timer > MAX_COYOTE_TIME:
				airborne = true

	if Main.game.cinematic_mode:
		action_prompt_meshinstance.position.y = 1000.0
		velocity.x = 0.0
		move_and_slide()
		
		if Input.is_action_just_pressed("Shoot"):
			Main.game.skip_cinematic()
		
		return

	if Input.is_action_just_pressed("Action"):
		execute_action()

	if Input.is_action_just_pressed("Jump"):
		print(coyote_timer)
		if not airborne:
			velocity.y = JUMP_VELOCITY
			airborne = true

	if Input.is_action_just_pressed("Shoot") and can_shoot:
		can_shoot = false
		gunshot_sprite.visible = true
		show_gunshot_timer.start()
		shoot_cd_timer.start()
		gun_player.play()

		var count_rats: bool = QuestTracker.main_quest_state in [
					QuestTracker.MainQuestState.KILL_FIRST_BATCH_RATS,
					QuestTracker.MainQuestState.KILL_SECOND_BATCH_RATS,
					QuestTracker.MainQuestState.KILL_THIRD_BATCH_RATS,
				]
		var rat_counter: int = 0

		for target in gun_targets:
			if is_instance_valid(target):
				target.kill()
				if count_rats and target is Rat:
					rat_counter += 1

		if rat_counter > 0:
			QuestTracker.decrement_counter(rat_counter)

		gun_targets.clear()

	var direction = Input.get_axis("Move Left", "Move Right")
	if abs(direction) > 0.0:
		has_moved = true
		look_dir = signf(direction)
		velocity.x = direction * SPEED
		Main.last_known_player_position = global_position
		update_direction_dependencies()
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * 4.0)

	var prev_push_x = push_x
	push_x *= pow(0.0001, delta)
	velocity.x += (push_x + prev_push_x) * 0.5

	move_and_slide()

func kill():
	var bloody_mess =  Main.bloody_mess_scene.instantiate()
	bloody_mess.position = position
	get_parent().add_child(bloody_mess)
	queue_free()


func _on_show_gunshot_timer_timeout():
	gunshot_sprite.visible = false


func _on_shoot_cd_timer_timeout():
	can_shoot = true


func _on_area_3d_body_entered(body):
	if body is Player:
		return

	if body.has_method("kill"):
		gun_targets.append(body)


func _on_area_3d_body_exited(body):
	gun_targets.erase(body)

func fill_bag():
	sprite_bagempty.visible = false
	sprite_bagfull.visible = true
	has_coal = true

func empty_bag():
	sprite_bagempty.visible = true
	sprite_bagfull.visible = false
	has_coal = false

func add_action_prompt(action_prompt: Utility.ActionPrompt):
	if action_prompt in action_prompts:
		return

	action_prompts.push_back(action_prompt)
	action_prompts.sort_custom(func(x, y): return x.priority < y.priority)
	update_action_prompt()

func remove_action_prompt(action_prompt: Utility.ActionPrompt):
	action_prompts.erase(action_prompt)
	update_action_prompt()

func update_action_prompt():
	if action_prompts.is_empty():
		action_prompt_meshinstance.visible = false
	else:
		action_prompt_meshinstance.visible = true
		action_prompt_meshinstance.mesh.text = action_prompts[0].message

func execute_action():
	if action_prompts.is_empty():
		return

	action_prompts[0].action_fn.call()
	action_prompts.pop_front()

	update_action_prompt()

func update_direction_dependencies():
	sprite_bagempty.flip_h = look_dir > 0.0
	sprite_bagfull.flip_h = sprite_bagempty.flip_h
	gunshot_sprite.position.x = gunshot_sprite_origin.x * (-1.0 if sprite_bagempty.flip_h else 1.0)
	gunshot_sprite.flip_h = sprite_bagempty.flip_h
