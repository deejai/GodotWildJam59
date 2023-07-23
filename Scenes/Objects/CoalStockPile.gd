extends Node3D


var action_prompt: Utility.ActionPrompt = Utility.ActionPrompt.new(
	"Pick Up Coal (E)",
	1,
	func():
		Main.player.fill_bag()
)

func _ready():
	pass


func _process(delta):
	pass




func _on_area_3d_body_entered(body):
	if body is Player and not body.has_coal:
		body.add_action_prompt(action_prompt)


func _on_area_3d_body_exited(body):
	if body is Player:
		body.remove_action_prompt(action_prompt)
