extends Node2D

var player: Player
var last_known_player_position: Vector3 = Vector3.ZERO

var bloody_mess_scene: PackedScene = load("res://Scenes/Particles/BloodyMess.tscn")
var rabbit_scene: PackedScene = load("res://Scenes/Characters/Rabbit.tscn")

func _ready():
	pass


func _process(delta):
	pass
