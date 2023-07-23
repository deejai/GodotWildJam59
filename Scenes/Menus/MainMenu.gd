extends Node2D

var game_scene: PackedScene = preload("res://Scenes/Game.tscn")

@onready var continue_button: Button = $Continue

func _ready():
	if Main.continue_starting_point > QuestTracker.MainQuestState.INTRO:
		continue_button.disabled = false
	else:
		continue_button.disabled = true


func _process(delta):
	pass


func _on_start_button_pressed():
	Main.continue_from_checkpoint = false
	get_tree().change_scene_to_packed(game_scene)


func _on_options_button_pressed():
	Main.pause_menu.pause_menu_modal.show()
	Main.pause_menu.options_buttons.show()
	Main.pause_menu.main_buttons.hide()


func _on_continue_pressed():
	Main.continue_from_checkpoint = true
	get_tree().change_scene_to_packed(game_scene)
