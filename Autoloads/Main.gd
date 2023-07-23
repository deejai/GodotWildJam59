extends Node2D

var game

var player: Player
var last_known_player_position: Vector3 = Vector3.ZERO

var bloody_mess_scene: PackedScene = load("res://Scenes/Particles/BloodyMess.tscn")
var rat_scene: PackedScene = load("res://Scenes/Characters/Rat.tscn")

var main_menu_scene: PackedScene = load("res://Scenes/Menus/MainMenu.tscn")

func _ready():
	pass


func _process(delta):
	pass
