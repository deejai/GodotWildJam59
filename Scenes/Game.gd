extends Node3D

@onready var camera: Camera3D = $Camera3D

func _ready():
	pass


func _process(delta):
	pass


func _on_rabbit_spawn_timer_timeout():
	var rabbit = Main.rabbit_scene.instantiate()
	rabbit.position = Vector3(randf_range(-15.0, 2.0), 10.0, 0.0)
	add_child(rabbit)
