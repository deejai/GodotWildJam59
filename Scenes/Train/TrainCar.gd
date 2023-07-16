extends Node3D

@onready var carbody: RigidBody3D = $CarBody
@onready var camera_anchor: Node3D = $CarBody/CameraAnchor

var next_impulse: float = 0.5 + randf()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	next_impulse -= delta
	if next_impulse <= 0.0:
		next_impulse += 0.3 + 0.8 * randf()
		carbody.apply_impulse(Vector3.UP * randf_range(0.25, 0.55), Vector3(randf_range(-2.0, 2.0), 0.0, randf_range(-0.5, 0.5)))


func _on_kill_zone_body_entered(body):
	if body.has_method("kill"):
		body.kill()


func _on_area_3d_body_entered(body):
	if body is Player:
		camera.make_current()
