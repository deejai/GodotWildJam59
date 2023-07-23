extends RigidBody3D

class_name Rat

var jump_timer: float

var direction: float = 1.0

@onready var sprite: Sprite3D = $Sprite3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var push_timer: Timer = $PushTimer
@onready var camera_anchor: Node3D = $CameraAnchor

var scaled_up: bool = false
var original_sprite_scale: Vector3

var action_prompt: Utility.ActionPrompt = Utility.ActionPrompt.new(
	"Harvest Rat",
	8,
	func():
		Main.game.play_speech_sequence("*squeeeeeeek*", camera_anchor)
		self.die = true
		QuestTracker.decrement_counter()
)

var die: bool = false

func reset_jump_timer():
	jump_timer += randf_range(1.0, 3.0)

func _ready():
	original_sprite_scale = sprite.scale
	sprite.scale = original_sprite_scale * 0.01

	position.z += 0.01 * randf()
	reset_jump_timer()
	_on_change_direction_timer_timeout()


func _process(delta):
	if not scaled_up:
		sprite.scale = lerp(sprite.scale, original_sprite_scale, 1.0 - pow(0.001, delta))
		if abs(sprite.scale.length_squared() - original_sprite_scale.length_squared()) < 0.01:
			sprite.scale = original_sprite_scale
			scaled_up = true

	if Main.game.cinematic_mode:
		return

	if die:
		kill()
		return

	jump_timer -= delta
	if jump_timer <= 0.0:
		apply_central_impulse(Vector3(direction * randf_range(1.0, 3.0), randf_range(1.0, 2.5), 0.0) * mass)
		push_timer.start()
		reset_jump_timer()

	if push_timer.is_stopped() == false:
		if is_instance_valid(Main.player):
			if Main.player.push_cd <= 0.0:
				if abs(Main.player.global_position.y - Main.player.y_offset - global_position.y) < 0.1 and abs(Main.player.global_position.x - (global_position.x + direction * 0.1)) < 0.15:
					Main.player.push_x = 5.0 * direction
					Main.player.velocity.y += 1.0
					Main.player.push_cd = 0.55

func kill():
	var bloody_mess =  Main.bloody_mess_scene.instantiate()
	bloody_mess.position = position
	get_parent().add_child(bloody_mess)
	if is_instance_valid(Main.player):
		Main.player.remove_action_prompt(action_prompt)
	queue_free()


func _on_change_direction_timer_timeout():
	if not is_instance_valid(Main.player):
		return

	direction = signf(Main.player.global_position.x - global_position.x)
	sprite.flip_h = direction > 0.0
	collision_shape.position.x = 0.082 * direction


func _on_area_3d_body_entered(body):
	if body is Player:
		if QuestTracker.main_quest_state == QuestTracker.MainQuestState.GET_FOOD_INGREDIENTS:
			action_prompt.message = "Harvest Tail (E)"
		elif QuestTracker.main_quest_state == QuestTracker.MainQuestState.GET_WEED_INGREDIENTS:
			action_prompt.message = "Harvest Whisker (E)"
		elif QuestTracker.main_quest_state == QuestTracker.MainQuestState.GET_DUST_INGREDIENTS:
			action_prompt.message = "Harvest Fang (E)"
		else:
			return

		body.add_action_prompt(action_prompt)

func _on_area_3d_body_exited(body):
	if body is Player:
		body.remove_action_prompt(action_prompt)
