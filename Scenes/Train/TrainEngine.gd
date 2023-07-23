extends Node3D

@onready var combustion_cylinders: Array = [$TrainCar/CarBody/trainengine/Sphere, $TrainCar/CarBody/trainengine/Sphere_002, $TrainCar/CarBody/trainengine/Sphere_004]
var combustion_cylinder_origins: Array = [] 
const COMBUSTION_CYLINDER_LEASH: float = 0.05
var time_passed: float = 0.0

func _ready():
	for cylinder in combustion_cylinders:
		combustion_cylinder_origins.append(cylinder.position)


func _process(delta):
	time_passed += delta

	for i in range(3):
		combustion_cylinders[i].position.y = combustion_cylinder_origins[i].y + COMBUSTION_CYLINDER_LEASH * sin(2 * PI * time_passed + (2.0/3.0) * PI * i)
