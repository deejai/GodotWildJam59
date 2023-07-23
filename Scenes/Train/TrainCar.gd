extends Node3D

@onready var carbody: RigidBody3D = $CarBody
@onready var camera_anchor: Node3D = $CarBody/CameraAnchor

var next_impulse: float = 0.5 + randf()

@export var music_theme: Game.MusicState

@export var show_robot: bool = false

@export var show_tombrandy: bool = false

func _ready():
	var robot: Sprite3D = get_node_or_null("CarBody/Robot")
	if robot:
		robot.visible = show_robot

	var tombrandy: Sprite3D = get_node_or_null("CarBody/Tombrandy")
	if tombrandy:
		tombrandy.visible = show_tombrandy

func _process(delta):
	next_impulse -= delta
	if next_impulse <= 0.0:
		next_impulse += 0.3 + 0.8 * randf()
		carbody.apply_impulse(Vector3.UP * randf_range(50.0, 100.0), Vector3(randf_range(-2.0, 2.0), 0.0, randf_range(-0.5, 0.5)))


func _on_area_3d_body_entered(body):
	if body is Player:
		print("switch")
		Main.game.camera_focus_node = camera_anchor
		Main.game.set_music_state(music_theme)


func _on_area_3d_body_exited(body):
	if body is Player:
		body.push_cd = 1.0
		print("Immune")
