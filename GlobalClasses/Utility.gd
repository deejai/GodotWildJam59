class_name Utility

class ActionPrompt:
	var message: String
	var priority: int
	var action_fn: Callable
	
	func _init(message: String, priority: int, action_fn: Callable):
		self.message = message
		self.priority = priority
		self.action_fn = action_fn

func _example():
	var x = ActionPrompt.new("r", 1, func(): pass)
	x.free()
