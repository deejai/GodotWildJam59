extends Node3D

var lifespan: float = 3.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	$CPUParticles3D.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifespan -= delta
	if lifespan <= 0.0:
		queue_free()
