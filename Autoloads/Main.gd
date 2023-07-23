extends Node2D

var game

var player: Player
var last_known_player_position: Vector3 = Vector3.ZERO

var bloody_mess_scene: PackedScene = preload("res://Scenes/Particles/BloodyMess.tscn")
var rat_scene: PackedScene = load("res://Scenes/Characters/Rat.tscn")

var main_menu_scene: PackedScene = load("res://Scenes/Menus/MainMenu.tscn")
var you_win_scene: PackedScene = load("res://Scenes/Menus/YouWin.tscn")

var hank
var karl

var speech_char_time_presets: Array[float] = [0.03, 0.06, 0.12]
var speech_char_time: float = speech_char_time_presets[1]

@onready var pause_menu: CanvasLayer = $PauseMenu

var continue_from_checkpoint: bool = false
var continue_starting_point: QuestTracker.MainQuestState = QuestTracker.MainQuestState.INTRO

func _ready():
	pass


func _process(delta):
	pass
