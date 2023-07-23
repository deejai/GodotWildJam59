extends Node2D

var game_scene: PackedScene = preload("res://Scenes/Game.tscn")


func _ready():
	pass


func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_options_button_pressed():
	pass
