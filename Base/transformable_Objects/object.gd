extends RigidBody

enum ObjectState{
	TRANSLATION,
	ROTATION,
	SCALE,
	PASSIVE
}

onready var _gizmo = $gizmo
# Position Variables
export var SpawnPoint : Vector3
export var currentPosition = Vector3.ZERO
export var nextPosition = Vector3.ZERO
# Object Movement Variables
export var translationSpeed = 4
export var rotationalSpeed = 2
var objectState

var direction


func _ready():
	_gizmo.visible = false
	SpawnPoint = global_translation
	currentPosition = SpawnPoint
	nextPosition = currentPosition
	add_to_group("TRANSFORMABLE")
	mode = MODE_KINEMATIC
	objectState = ObjectState.PASSIVE
	
func _physics_process(delta):
	match objectState:
		ObjectState.TRANSLATION:
			if (currentPosition - nextPosition).length() > 0.1:
				direction = (nextPosition - currentPosition).normalized()
				global_translation += (direction)  * delta * translationSpeed
			else:
				objectState = ObjectState.PASSIVE
		ObjectState.ROTATION:
			pass
		ObjectState.PASSIVE:
			pass
	
		
	
# warning-ignore:unused_argument
func _process(delta):
		currentPosition = global_translation
		
func moveObject(vPosition: Vector3):
	nextPosition = currentPosition + vPosition
	objectState = ObjectState.TRANSLATION 
	
func rotateObject(vPosition: Vector3):
	pass

## Area on Top of object which signals the player to move differently depending on floor/platform
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Platform # Change player movement to platform type
		#print(body.floor_state)
func _on_Area_body_exited(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Floor # Change player movement to floor type.
		#print(body.floor_state)
