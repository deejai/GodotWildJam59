extends Node3D

var cactus_scene: PackedScene = load("res://Scenes/Objects/Cactus.tscn")
@onready var meshinstance: MeshInstance3D = $MeshInstance3D
@onready var mesh: QuadMesh = $MeshInstance3D.mesh
@onready var train_tracks_node: Node3D = $TrainTracks

func _ready():
	randomize_scene()

	for vertex in mesh.get_faces():
		if (vertex.y < -0.0 and vertex.y > -1.5) or vertex.y < -2.0:
			continue

		if randf() < .99:
			continue

		var cactus = cactus_scene.instantiate()
		cactus.position = vertex
		meshinstance.add_child(cactus)
		cactus.global_rotation = Vector3(0.0, 0.0, 0.0)

func _process(delta):
	position.x -= 10.0 * delta

	if position.x <= Main.last_known_player_position.x - 30.0:
		position.x += 60.0
		randomize_scene()

func randomize_scene():
	for tracks in train_tracks_node.get_children():
		tracks.randomize_scene()
