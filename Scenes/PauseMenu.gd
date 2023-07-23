extends CanvasLayer

@onready var pause_menu_modal: ColorRect = $PauseMenu
@onready var confirm_quit_modal: ColorRect = $PauseMenu/ConfirmModal
@onready var options_buttons: VBoxContainer = $PauseMenu/OptionsButtons
@onready var main_buttons: VBoxContainer = $PauseMenu/MainButtons

@onready var slow_speech_checkbox: CheckBox = $PauseMenu/OptionsButtons/SpeechContainer/SlowCheckbox
@onready var med_speech_checkbox: CheckBox = $PauseMenu/OptionsButtons/SpeechContainer/MediumCheckbox
@onready var fast_speech_checkbox: CheckBox = $PauseMenu/OptionsButtons/SpeechContainer/FastCheckbox

@onready var volume_slider: HSlider = $PauseMenu/OptionsButtons/VolumeContainer/Panel/HSlider

@onready var test_sound: AudioStreamPlayer = $TestSound

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if Input.is_action_just_pressed("Pause") and is_instance_valid(Main.game):
		if get_tree().paused:
			pause_menu_modal.hide()
			get_tree().paused = false
		else:
			pause_menu_modal.show()
			main_buttons.show()
			options_buttons.hide()
			confirm_quit_modal.hide()
			get_tree().paused = true


func _on_confirm_quit_pressed():
	confirm_quit_modal.hide()
	pause_menu_modal.hide()
	get_tree().paused = false
	get_tree().change_scene_to_packed(Main.main_menu_scene)


func _on_cancel_quit_pressed():
	main_buttons.show()
	confirm_quit_modal.hide()


func _on_quit_pressed():
	main_buttons.hide()
	confirm_quit_modal.show()


func _on_return_to_game_pressed():
	get_tree().paused = false
	pause_menu_modal.hide()


func _on_options_pressed():
	main_buttons.hide()
	options_buttons.show()


func _on_options_return_pressed():
	main_buttons.show()

	if is_instance_valid(Main.game):
		options_buttons.hide()
	else:
		pause_menu_modal.hide()

func _on_slow_checkbox_pressed():
	Main.speech_char_time = Main.speech_char_time_presets[2]

func _on_medium_checkbox_pressed():
	Main.speech_char_time = Main.speech_char_time_presets[1]

func _on_fast_checkbox_pressed():
	Main.speech_char_time = Main.speech_char_time_presets[0]

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	test_sound.play()
