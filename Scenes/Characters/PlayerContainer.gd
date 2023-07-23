extends Node3D

@onready var player: Player = $Player

func _ready():
	pass


func _process(delta):
	if not is_instance_valid(player):
		return
