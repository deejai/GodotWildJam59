extends Node3D

class_name Game

@export var starting_camera_focus_node: Node3D
@export var coal_pile: Node3D

@onready var camera: Camera3D = $Camera3D
@onready var camera_focus_node: Node3D = starting_camera_focus_node

@onready var hud: CanvasLayer = $HUD

var cinematic_mode: bool = false
var cinematic_camera_focus_node: Node3D

const SPEECH_CHAR_TIME: float = 0.05
var speech_char_timer: float = 0.0
var speech_lines: Array[Array] = []
const NEXT_LINE_TIME: float = 0.5
var next_line_timer: float

var hank
var karl

var game_over_reset_timer: float = 2.0

enum MusicState {NONE, MAIN_ONLY, HANK, KARL, PASSENGER}
var music_state: MusicState = MusicState.MAIN_ONLY
@onready var music_main_theme: AudioStreamPlayer = $MainTheme
var music_main_theme_target_db: float = -10.0
@onready var music_hank_stem: AudioStreamPlayer = $HankThemeStem
var music_hank_stem_target_db: float = -9999.0
@onready var music_karl_stem: AudioStreamPlayer = $KarlThemeStem
var music_karl_stem_target_db: float = -9999.0
@onready var music_passenger_stem: AudioStreamPlayer = $PassengerThemeStem
var music_passenger_stem_target_db: float = -9999.0

func _ready():
	QuestTracker.reset()
	Main.game = self
	camera.global_position = camera_focus_node.global_position

func _process(delta):
	if not is_instance_valid(Main.player):
		game_over_reset_timer -= delta
		if game_over_reset_timer <= 0.0:
			get_tree().change_scene_to_packed(Main.main_menu_scene)

	if cinematic_mode:
		camera.global_position = lerp(camera.global_position, cinematic_camera_focus_node.global_position, 1-pow(1-.95, delta))

		if next_line_timer > 0.0:
			next_line_timer -= delta
			if next_line_timer <= 0.0:
				hud.speech_text_label.text = ""

		if next_line_timer <= 0.0:
			if speech_lines.is_empty():
				cinematic_mode = false
				hud.hide_speech()
			else:
				speech_char_timer -= delta
				while speech_char_timer <= 0.0 and not speech_lines[0].is_empty():
					speech_char_timer += SPEECH_CHAR_TIME
					hud.speech_text_label.text += speech_lines[0].pop_front()
				
				if speech_lines[0].is_empty():
					speech_lines.pop_front()
					next_line_timer = NEXT_LINE_TIME
	else:
		camera.global_position = lerp(camera.global_position, camera_focus_node.global_position, 1.0-pow(1.0-.95, delta))

	music_main_theme.volume_db = lerpf(music_main_theme.volume_db, music_main_theme_target_db, 1.0-pow(1.0-0.95, delta))
	music_hank_stem.volume_db = lerpf(music_hank_stem.volume_db, music_hank_stem_target_db, 1.0-pow(1.0-0.95, delta))
	music_karl_stem.volume_db = lerpf(music_karl_stem.volume_db, music_karl_stem_target_db, 1.0-pow(1.0-0.95, delta))
	music_passenger_stem.volume_db = lerpf(music_passenger_stem.volume_db, music_passenger_stem_target_db, 1.0-pow(1.0-0.95, delta))


func play_speech_sequence(text: String, camera_anchor: Node3D):
	var words: PackedStringArray = text.split(" ")
	var word_index: int = 0
	var lines: Array[Array] = [[]]
	var line_num: int = 0
	const line_char_limit: int = 44
	while word_index < len(words):
		var next_word: String = words[word_index]
		word_index += 1
		if len(lines[line_num]) + len(next_word) > line_char_limit:
			lines.append([])
			line_num += 1

		if len(lines[line_num]) > 0:
			lines[line_num].append(" ")

		for char in next_word:
			lines[line_num].append(char)

	cinematic_mode = true
	cinematic_camera_focus_node = camera_anchor

	hud.speech_text_label.text = ""
	hud.show_speech()
	speech_lines = lines
	speech_char_timer = SPEECH_CHAR_TIME
	next_line_timer = 0.75

func _on_kill_zone_body_entered(body):
	if body.has_method("kill"):
		body.kill()


func skip_cinematic():
	if not cinematic_mode:
		return

	if hud.skip_label.modulate.a <= 0.1:
		hud.skip_label.modulate.a = 1.1
	else:
		speech_lines = []
		hud.hide_speech()
		cinematic_mode = false

func set_music_state(music_state: MusicState):
	if QuestTracker.main_quest_state >= QuestTracker.MainQuestState.CHECK_ON_KARL:
		music_state = MusicState.NONE

	self.music_state = music_state

	music_main_theme_target_db = -10.0 if music_state != MusicState.NONE else -9999.0
	music_hank_stem_target_db = -10.0 if music_state == MusicState.HANK else -9999.0
	music_karl_stem_target_db = -10.0 if music_state == MusicState.KARL else -9999.0
	music_passenger_stem_target_db = -1.0 if music_state == MusicState.PASSENGER else -9999.0
