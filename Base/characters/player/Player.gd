extends KinematicBody

# Signals

# Enums
## Player States
enum PlayerFloorState{Floor, Platform}
# Constants

# Exported Variables
export var speed = 10
export var acceleration = 10
export var jump = 8
export var gravity = 18.2
export var coyoteTime = 0.2
# Regular Variables
var coyoteTimeCounter = 0.0
var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var prevDirection = Vector3.ZERO
var cameraIsActive = false # first person camera
var SpawnPoint
var snap_vector
var picked_Object # Unused
var floor_state
# Onready Variables
onready var _body = $Body
onready var _camera = $Camera
onready var interaction = $Camera/firstPerson/RayCast # Is this used?

func _ready():
	show()
	SpawnPoint = global_translation
	prevDirection = _camera.rotation
	add_to_group("Player")
	floor_state = PlayerFloorState.Floor # 
	
	
func _physics_process(delta):
	# Set player movement to WASD controls, normalize and rotate so direction moved is always the camera front
	direction = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		0,
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	).normalized().rotated(Vector3.UP, _camera.rotation.y)
	
	# Sync Camera when switching
	if _body.visible:
		if direction != Vector3.ZERO:
			_body.look_at(translation + direction, Vector3.UP)
			prevDirection = _body.rotation
	else:
		_body.rotation.y = _camera.rotation.y
		prevDirection = _body.rotation
	# Interpolate current velocity to desired velocity
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta) 
	velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	snap_vector = get_floor_normal()
	_jump(delta) # Check for jump inputs
	# Finally move player
	
#	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true,1, 0.785398, true)
#	velocity = move_and_slide(velocity, Vector3.UP)
	match floor_state:
		PlayerFloorState.Floor:
			velocity = move_and_slide(velocity, Vector3.UP)
		PlayerFloorState.Platform:
			velocity = move_and_slide_with_snap(velocity, -snap_vector , Vector3.UP, true,1, 0.785398, true)


func _jump(delta):
	# Coyote time based jumps 
	
	if is_on_floor():
		coyoteTimeCounter = coyoteTime
	else:	
		velocity.y -= gravity * delta # Sets gravity
		coyoteTimeCounter -= delta
		
	if coyoteTimeCounter > 0.0 and Input.is_action_just_pressed("jump"):
		snap_vector = Vector3.ZERO
		velocity.y = jump
	if (Input.is_action_just_released("jump") and velocity.y > 0.0):
		coyoteTimeCounter = 0.0


func _on_level_test_camera_toggled():
	cameraIsActive = !cameraIsActive
	_camera.get_node("firstPerson").set_process(cameraIsActive)
	if cameraIsActive:
		_camera.get_node("firstPerson").make_current()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_body.visible = false
		_camera.look_rotation.y = rad2deg(prevDirection.y)
		_camera.look_rotation.x = rad2deg(prevDirection.x)
	else:
		_body.visible = true
		
