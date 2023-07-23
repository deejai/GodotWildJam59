extends Node2D


var ignore_input_timer: float = 2.5

func _ready():
	pass


func _process(delta):
	ignore_input_timer -= delta
	
	if Input.is_anything_pressed() and ignore_input_timer <= 0.0:
		get_tree().change_scene_to_packed(Main.main_menu_scene)
