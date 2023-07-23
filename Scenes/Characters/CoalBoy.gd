extends Node3D


@onready var arm_lower_foreground: RigidBody3D = $ArmLowerForeground
@onready var arm_lower_background: RigidBody3D = $ArmLowerBackground
@onready var shovel: RigidBody3D = $Shovel

var shovel_timer: float = 0.0

var shovel_dir: float = 1.0

var shovel_interval: float = 1.0

const VOICE_CD: float = 3.0
var voice_cd_timer: float = 6.0
@onready var voice_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var camera_anchor: Node3D = $CameraAnchor

@onready var passed_out_sprite: Sprite3D = $PassedOut

var action_prompt: Utility.ActionPrompt = Utility.ActionPrompt.new(
	"Talk to Karl",
	5,
	func(): printerr("Empty action from Karl")
)

var last_main_quest_state: QuestTracker.MainQuestState = QuestTracker.MainQuestState.INTRO

func _ready():
	Main.karl = self


func _process(delta: float):
	if not Main.game.cinematic_mode:
		voice_cd_timer -= delta

	shovel_timer = fmod(shovel_timer + delta, shovel_interval)

	if shovel_timer < shovel_interval * 0.65:
		arm_lower_foreground.apply_central_force(Vector3.RIGHT * -3.0)
	else:
		arm_lower_foreground.apply_central_force((Vector3.RIGHT) * 1.5)

		if shovel_timer > shovel_interval * 0.8:
			arm_lower_background.apply_central_impulse(Vector3.UP * 0.3)
		else:
			arm_lower_background.apply_central_force(Vector3.UP * 0.7)



func _on_area_3d_body_entered(body):
	if body is Player:
		if voice_cd_timer <= 0.0 and QuestTracker.main_quest_state < QuestTracker.MainQuestState.CHECK_ON_KARL:
			voice_player.play()
			voice_cd_timer = VOICE_CD + 0.5 * randf()

		if not QuestTracker.did_karl_intro:
			Main.game.play_speech_sequence(QuestTracker.karl_intro_line, camera_anchor)
			QuestTracker.did_karl_intro = true
			QuestTracker.progress_main_quest()

		var current_quest = QuestTracker.quests[QuestTracker.main_quest_state]

		if QuestTracker.main_quest_state != last_main_quest_state:
			last_main_quest_state = QuestTracker.main_quest_state

			if current_quest.speaker == QuestTracker.QuestSpeaker.KARL:
				action_prompt.message = current_quest.description + " (E)"
				action_prompt.action_fn = func():
					Main.game.play_speech_sequence(current_quest.speech, camera_anchor)
					QuestTracker.progress_main_quest()

		if current_quest.speaker == QuestTracker.QuestSpeaker.KARL:
			body.add_action_prompt(action_prompt)

func _on_area_3d_body_exited(body):
	if body is Player:
		body.remove_action_prompt(action_prompt)

func pass_out():
	for child in get_children():
		child.visible = false

	passed_out_sprite.visible = true
