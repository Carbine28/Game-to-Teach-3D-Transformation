extends KinematicBody

onready var _gizmo = $gizmo
# Position Variables
export var SpawnPoint : Vector3
export var currentPosition = Vector3.ZERO
export var nextPosition = Vector3.ZERO
# Object Movement Variables
export var speed = 2
var direction

func _ready():
	_gizmo.visible = false
	SpawnPoint = global_translation
	currentPosition = SpawnPoint
	nextPosition = currentPosition
	add_to_group("TRANSFORMABLE")
	
func _physics_process(delta):
	if (currentPosition - nextPosition).length() > 0.1:
		var direction = (nextPosition - currentPosition).normalized()
		#move_and_slide(direction * speed, Vector3.UP)
		
	
func _process(delta):
		currentPosition = global_translation
		
func moveObject(vPosition: Vector3):
	nextPosition = currentPosition + vPosition 
