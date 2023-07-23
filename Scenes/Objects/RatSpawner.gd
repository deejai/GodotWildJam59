extends Node3D

var spawn_timer: float

func _ready():
	spawn_timer = 1.0 + 2.0 * randf()


func _process(delta):
	if Main.game.cinematic_mode:
		return

	spawn_timer -= delta

	if spawn_timer <= 0.0 and Main.game.rat_count < 10:
		reset_spawn_timer()

		var rat = Main.rat_scene.instantiate()
		rat.position = Vector3(global_position.x + randf_range(-0.1, 0.1), global_position.y + 0.0, 0.0)
		get_parent().add_child(rat)

func reset_spawn_timer():
	spawn_timer = 6.0 + 12.0 * randf()
