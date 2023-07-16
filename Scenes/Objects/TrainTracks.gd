extends Node3D

@onready var track_meshinstance_background: MeshInstance3D = $TrackMeshBackground
@onready var track_meshinstance_foreground: MeshInstance3D = $TrackMeshForeground
@onready var ties_node: Node3D = $Ties

func _ready():
	pass


func _process(delta):
	pass


func randomize_scene():
	track_meshinstance_background.rotation.y = randf_range(-PI/256, PI/256)
	track_meshinstance_foreground.rotation.y = randf_range(-PI/256, PI/256)
	for tie in ties_node.get_children():
		tie.rotation.y = randf_range(-PI/24, PI/24)
		tie.position.y = randf_range(-.03, .03)
