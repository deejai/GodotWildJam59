extends Node3D

class_name Game

@export var starting_camera_focus_node: Node3D
@export var coal_pile: Node3D

@onready var camera: Camera3D = $Camera3D
@onready var camera_focus_node: Node3D = starting_camera_focus_node

@onready var hud: CanvasLayer = $HUD

var cinematic_mode: bool = false
var cinematic_camera_focus_node: Node3D

var speech_char_timer: float = 0.0
var speech_lines: Array[Array] = []
const NEXT_LINE_TIME: float = 0.35
var next_line_timer: float

var game_over_reset_timer: float = 2.0

@onready var short_sad_violin_player: AudioStreamPlayer = $ShortSadViolinPlayer

enum MusicState {NONE, MAIN_ONLY, HANK, KARL, PASSENGER}
var music_state: MusicState = MusicState.MAIN_ONLY
@onready var music_main_theme: AudioStreamPlayer = $MainTheme
var music_main_theme_target_db: float = -10.0
@onready var music_hank_stem: AudioStreamPlayer = $HankThemeStem
var music_hank_stem_target_db: float = -40.0
@onready var music_karl_stem: AudioStreamPlayer = $KarlThemeStem
var music_karl_stem_target_db: float = -40.0

var soften_music_timer: float = 0.0

var you_win: bool = false
var you_win_timer: float = 2.0

var rat_count: int = 0

func _ready():
	QuestTracker.reset()
	Main.game = self
	camera.global_position = camera_focus_node.global_position

	if Main.continue_from_checkpoint:
		QuestTracker.main_quest_state = Main.continue_starting_point
		QuestTracker.did_karl_intro = true
		QuestTracker.did_hank_intro = true

func _process(delta):
	if not is_instance_valid(Main.player):
		hud.fade_out = true
		game_over_reset_timer -= delta
		if game_over_reset_timer <= 0.0:
			get_tree().change_scene_to_packed(Main.main_menu_scene)

	soften_music_timer -= delta

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
					speech_char_timer += Main.speech_char_time
					hud.speech_text_label.text += speech_lines[0].pop_front()
				
				if speech_lines[0].is_empty():
					speech_lines.pop_front()
					next_line_timer = NEXT_LINE_TIME + 5.0 * Main.speech_char_time
	else:
		camera.global_position = lerp(camera.global_position, camera_focus_node.global_position, 1.0-pow(1.0-.95, delta))

	music_main_theme.volume_db = move_toward(music_main_theme.volume_db, music_main_theme_target_db if soften_music_timer <= 0.0 else -40.0, 7.5 * delta)
	music_hank_stem.volume_db = move_toward(music_hank_stem.volume_db, music_hank_stem_target_db if soften_music_timer <= 0.0 else -40.0, 7.5 * delta)
	music_karl_stem.volume_db = move_toward(music_karl_stem.volume_db, music_karl_stem_target_db if soften_music_timer <= 0.0 else -40.0, 7.5 * delta)

	if you_win and not cinematic_mode:
		hud.fade_out = true
		you_win_timer -= delta
		if you_win_timer <= 0.0:
			get_tree().change_scene_to_packed(Main.you_win_scene)

func play_speech_sequence(text: String, camera_anchor: Node3D, next_line_timer: float = 0.75):
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
	speech_char_timer = Main.speech_char_time
	self.next_line_timer = next_line_timer

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

	music_main_theme_target_db = -10.0 if music_state != MusicState.NONE else -40.0
	music_hank_stem_target_db = -10.0 if music_state == MusicState.HANK else -40.0
	music_karl_stem_target_db = -10.0 if music_state == MusicState.KARL else -40.0

func soften_music(duration: float):
	soften_music_timer = max(soften_music_timer, duration)
