extends CanvasLayer

@onready var coal_remaining_bar: TextureProgressBar = $Textures/CoalRemainingBar
@onready var coal_remaining_text: RichTextLabel = $Text/RichTextLabel
@onready var journal_details: RichTextLabel = $Text/JournalDetails

@onready var speech_node: Node = $Speech
@onready var speech_text_label: RichTextLabel = $Speech/SpeechText/RichTextLabel

@onready var text: CanvasLayer = $Text
@onready var textures: CanvasLayer = $Textures

@onready var skip_label: RichTextLabel = $Speech/SpeechText/SkipLabel

var time_passed: float = 0.0

func _ready():
	hide_speech()
	update_journal_details()
	skip_label.modulate.a = 0.0

func _process(delta):
	time_passed += delta

	var scale_intensity: float = 0.0 if Main.game.coal_pile.coal_pct > 60.0 else 0.2 * pow((100.0 - Main.game.coal_pile.coal_pct) / 100.0, 2)
	coal_remaining_text.scale = Vector2(1.0, 1.0) * (1.0 - (scale_intensity * 0.5) + scale_intensity * sin(2.0 * PI * time_passed))

	skip_label.modulate.a = max(0.0, skip_label.modulate.a - delta)
	coal_remaining_bar.value = Main.game.coal_pile.coal_pct

func update_journal_details():
	var progress = QuestTracker.main_quest_state

	var text: String = ""

	if QuestTracker.main_quest_state > 2:
		text += "[color=gray][s]" + QuestTracker.quests[progress-2].description + "[/s][/color]\n"

	if QuestTracker.main_quest_state > 1:
		text += "[color=gray][s]" + QuestTracker.quests[progress-1].description + "[/s][/color]\n"

	text = text.replace("__COUNTER__", "")
	text = text.replace("  ", " ")

	if QuestTracker.main_quest_state > 0:
		text += QuestTracker.quests[progress].description

	text = text.replace("__COUNTER__", str(QuestTracker.quest_counter))

	journal_details.text = text

func hide_speech():
	for child in speech_node.get_children():
		child.visible = false

	text.visible = true
	textures.visible = true

func show_speech():
	for child in speech_node.get_children():
		child.visible = true

	text.visible = false
	textures.visible = false
