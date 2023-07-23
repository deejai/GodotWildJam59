extends Node3D

@onready var voice_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
const VOICE_CD: float = 3.0
var voice_cd_timer: float = 6.0

@onready var camera_anchor: Node3D = $CameraAnchor

var action_prompt: Utility.ActionPrompt = Utility.ActionPrompt.new(
	"Talk to Hank",
	5,
	func(): printerr("Empty action from Hank")
)

var last_main_quest_state: QuestTracker.MainQuestState = QuestTracker.MainQuestState.INTRO

func _ready():
	pass


func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body is Player:
		if voice_cd_timer <= 0.0:
			voice_player.play()
			voice_cd_timer = VOICE_CD + 0.5 * randf()

		if not QuestTracker.did_hank_intro:
			Main.game.play_speech_sequence(QuestTracker.hank_intro_line, camera_anchor)
			QuestTracker.did_hank_intro = true

		var current_quest = QuestTracker.quests[QuestTracker.main_quest_state]

		if QuestTracker.main_quest_state != last_main_quest_state:
			last_main_quest_state = QuestTracker.main_quest_state

			if current_quest.speaker == QuestTracker.QuestSpeaker.HANK:
				action_prompt.message = current_quest.description + " (E)"
				action_prompt.action_fn = func():
					Main.game.play_speech_sequence(current_quest.speech, camera_anchor)
					QuestTracker.progress_main_quest()

		if current_quest.speaker == QuestTracker.QuestSpeaker.HANK:
			body.add_action_prompt(action_prompt)

func _on_area_3d_body_exited(body):
	if body is Player:
		body.remove_action_prompt(action_prompt)
