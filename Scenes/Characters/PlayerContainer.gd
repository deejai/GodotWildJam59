extends Node3D

@onready var player: Player = $Player
#@onready var camera_neck: Node3D = $CameraNeck
#var camera_focus_x: float
#var camera_jerk_lerp: float = 0.5
#var camera_settle_lerp: float = 0.98
#var camera_y_origin: float
#var camera_y_boost: float = 0.0

#var cinematic_mode: bool = false

func _ready():
#	camera_y_origin = camera_neck.position.y
#	camera_focus_x = player.position.x
	pass


func _process(delta):
	if not is_instance_valid(player):
		return
#	if player.has_moved and not cinematic_mode:
#		var player_look_offset: float = player.look_dir * .5
##		$LookPoint.position.x = player.position.x + player_look_offset
##		$CameraFocus.position.x = camera_focus_x
#
#		camera_focus_x = lerpf(camera_focus_x, player.position.x + player_look_offset, 1-pow(1-camera_settle_lerp,delta))
#
#		camera_neck.position.x = lerpf(camera_neck.position.x, camera_focus_x, 1-pow(1-camera_jerk_lerp,delta))
#
#		var camera_excitement: float = camera_neck.position.x - camera_focus_x
#		camera_neck.rotation.y = clampf((camera_excitement) * PI/64, -PI/64, PI/64)
#		camera_y_boost = abs(camera_excitement) * 0.1
#		camera_neck.position.y = camera_y_origin + camera_y_boost
