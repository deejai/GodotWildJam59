extends Node3D

var coal_pct: float = 100.0
const CONSUMPTION_RATE: float = 1.25
enum State {NONE, SMALL, MED, LARGE}
var state = State.LARGE

@onready var small_sprite: Sprite3D = $SpriteSmall
@onready var medium_sprite: Sprite3D = $SpriteMedium
@onready var large_sprite: Sprite3D = $SpriteLarge

var action_prompt: Utility.ActionPrompt = Utility.ActionPrompt.new(
	"Drop Off Coal (E)",
	1,
	func():
		Main.player.empty_bag()
		Main.game.coal_pile.coal_pct = 100.0
)

func _ready():
	pass

func _process(delta):
	if Main.game.cinematic_mode or QuestTracker.main_quest_state >= QuestTracker.MainQuestState.CHECK_ON_KARL:
		return

	coal_pct -= delta * CONSUMPTION_RATE

	if coal_pct <= 1.0:
		if state != State.NONE:
			state = State.NONE
			small_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = false

	elif coal_pct < 33.0:
		if state != State.SMALL:
			state = State.SMALL
			small_sprite.visible = true
			medium_sprite.visible = false
			large_sprite.visible = false

	elif coal_pct < 67.0:
		if state != State.MED:
			state = State.MED
			small_sprite.visible = false
			medium_sprite.visible = true
			large_sprite.visible = false

	else:
		if state != State.LARGE:
			state = State.LARGE
			small_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = true


func _on_area_3d_body_entered(body):
	if body is Player and body.has_coal:
		body.add_action_prompt(action_prompt)


func _on_area_3d_body_exited(body):
	if body is Player:
		body.remove_action_prompt(action_prompt)
