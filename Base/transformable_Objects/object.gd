extends RigidBody

signal transform_finished

enum ObjectState{
	TRANSLATION,
	ROTATION,
	SCALE,
	PASSIVE
}

onready var _gizmo = $gizmo
# Default Position Variables
var SpawnPoint : Vector3
var defaultRotation: Vector3
# Position Variables
export var currentPosition = Vector3.ZERO
export var currentRotation = Vector3.ZERO
# Future Transformation Variables
var targetPosition = Vector3.ZERO
var targetRotation = Vector3.ZERO
var targetScale = Vector3.ZERO
# Object Movement Variables
export var translationSpeed = 4
var _anglularSpeed: float = TAU
var angular_accel = 5
var angle_diff_x
var angle_diff_y
var angle_diff_z

var objectState
var direction
var rotLocked

var lookBasis = Basis()
var rotation_lerp:= 0.0
var rotation_speed:= 0.8
var currentScale;

func _ready():
	# Connect Signal To Transformable GUI . Emit a signal per action committed
	var _gui = get_tree().root.get_child(0).get_node("World/../GUI/TransformableGUI")
	connect("transform_finished", _gui, "_on_Transform_Finished")
	_gizmo.set_as_toplevel(true) # Prevent rotation from affecting gizmo
	_gizmo.visible = false # Hide Axis Gizmo
	
	SpawnPoint = global_translation
	defaultRotation = global_rotation
	
	currentPosition = SpawnPoint
	currentRotation = defaultRotation
	rotLocked = false
	currentScale = scale
	
	targetPosition = currentPosition
	add_to_group("TRANSFORMABLE")
	mode = MODE_KINEMATIC
	objectState = ObjectState.PASSIVE

func _process(delta):
		currentPosition = global_translation
		match objectState:
			ObjectState.TRANSLATION:
				if (currentPosition - targetPosition).length() > 0.1:
					direction = (targetPosition - currentPosition).normalized()
#					global_translation += (direction)  * delta * translationSpeed
					translation += (direction)  * delta * translationSpeed
					_gizmo.global_translation = translation
				else:
					objectState = ObjectState.PASSIVE
					emit_signal("transform_finished")
			ObjectState.ROTATION:
					if rotation_lerp < 1:
						rotation_lerp += delta * rotation_speed
					elif rotation_lerp > 1:
						rotation_lerp = 1
					rotation.y = lerp_angle(rotation.y, targetRotation.y, rotation_lerp )
					if rotation_lerp == 1:
#						transform = transform.orthonormalized()
#						transform = transform.scaled(currentScale)
						print(currentScale)
						objectState = ObjectState.PASSIVE
						rotLocked = false
						emit_signal("transform_finished")
			ObjectState.SCALE:
					scale_object_local(targetScale)
					currentScale = targetScale
					_gizmo.scale = targetScale # Scale gizmo relative to object
#					transform = transform.orthonormalized()
#					transform = transform.scaled(currentScale)
					objectState = ObjectState.PASSIVE
					emit_signal("transform_finished")
			ObjectState.PASSIVE:
				pass
							
func moveObject(vPosition: Vector3):
	targetPosition = currentPosition + vPosition
	objectState = ObjectState.TRANSLATION 
	
func rotateObject(vRotation: Vector3):
	if not rotLocked:
		targetRotation.y += deg2rad(vRotation.y)
		rotation_lerp = 0
		objectState = ObjectState.ROTATION
		rotLocked = true

func scaleObject(vScale: Vector3):
	targetScale = vScale
	objectState = ObjectState.SCALE
## Area on Top of object which signals the player to move differently depending on floor/platform
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Platform # Change player movement to platform type
		#print(body.floor_state)
func _on_Area_body_exited(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Floor # Change player movement to floor type.
		#print(body.floor_state)
