extends Node3D

#@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
#@onready var wheel_model: Node3D = $wheel
const rot_per_sec: float = 1.0


func _ready():
	pass # Replace with function body.


func _process(delta):
	rotation.z -= 2 * PI * delta * rot_per_sec
