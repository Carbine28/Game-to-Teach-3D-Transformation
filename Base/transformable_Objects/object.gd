extends RigidBody
# Signals
signal transform_finished
# Enums
enum ObjectState{ TRANSLATION, ROTATION, SCALE, PASSIVE}
# Exports
export(bool) var can_translate
export(bool) var can_rotate
export(bool) var can_scale
export(bool) var has_limit = false
export var transform_limit: int = 5
export(Vector3) var translate_limit = Vector3(0, 0, 0)
export(Vector3) var rotate_limit = Vector3(0, 0, 0)
export var translation_speed = 4
# Regular Variables
var objectState
var direction
var rotLocked
var lookBasis = Basis() # Not used
var rotation_lerp:= 0.0
var rotation_speed:= 0.7
var currentScale;
# Default Position Variables
var SpawnPoint : Vector3
var defaultRotation: Vector3
# Position Variables
var currentPosition = Vector3.ZERO
var currentRotation = Vector3.ZERO
# Future Transformation Variables
var targetPosition = Vector3.ZERO
var targetRotation = Vector3.ZERO
var targetAxis
var targetScale = Vector3.ZERO
# Object Movement Variables
var _anglularSpeed: float = TAU
var angular_accel = 5
var angle_diff_x
var angle_diff_y
var angle_diff_z
# Onready variables
onready var _gizmo = $gizmo


func _ready():
	# Connect Signal To Transformable GUI . Emit a signal per action committed
	var _gui = get_tree().root.get_child(0).get_node("World/../GUI/TransformableGUI")
	var err_code = connect("transform_finished", _gui, "_on_Transform_Finished")
	if err_code:
		print("ERROR: ", err_code)
	
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
					translation += (direction)  * delta * translation_speed
					_gizmo.global_translation = translation
				else:
					objectState = ObjectState.PASSIVE
					emit_signal("transform_finished")
			ObjectState.ROTATION:
					if rotation_lerp < 1:
						rotation_lerp += delta * rotation_speed
					elif rotation_lerp > 1:
						rotation_lerp = 1
					match targetAxis:
						0:	
							print(rotation.x)
							if rotation.x == targetRotation.x:
								rotation_lerp = 1
							else:
								rotation.x = lerp_angle(rotation.x, targetRotation.x, rotation_lerp )
						1:
							if rotation.y == targetRotation.y:
								rotation_lerp = 1
							else:
								rotation.y = lerp_angle(rotation.y, targetRotation.y, rotation_lerp )
						2:
							if rotation.z == targetRotation.z:
								rotation_lerp = 1
							else:
								rotation.z = lerp_angle(rotation.z, targetRotation.z, rotation_lerp )
					if rotation_lerp == 1:
						rotation = targetRotation
#						transform = transform.orthonormalized()
#						transform = transform.scaled(currentScale)
#						print(currentScale)
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

	
func rotateObject(axis: int , value: float):
	if not rotLocked:
		rotLocked = true
		
		targetAxis = axis
		if targetAxis == 1:
			targetRotation.y += deg2rad(value)
		elif targetAxis == 0:
			targetRotation.x += deg2rad(value)
		else:
			targetRotation.z += deg2rad(value)
			
		rotation_lerp = 0
		objectState = ObjectState.ROTATION
		

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
