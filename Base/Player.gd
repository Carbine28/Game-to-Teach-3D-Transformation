extends KinematicBody

onready var _body = $Body
onready var _camera = $Camera
# Used for first person picking? But do we really need it
onready var interaction = $Camera/firstPerson/RayCast
var picked_Object

export var speed = 10
export var acceleration = 10
export var jump = 8
export var gravity = 18.2

export var coyoteTime = 0.2
var coyoteTimeCounter = 0.0

var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var prevDirection = Vector3.ZERO
var cameraIsActive = false
var defaultSpawnPoint

func _ready():
	defaultSpawnPoint = global_translation
	prevDirection = _camera.rotation

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
	_jump(delta) # Check for jump inputs
	# Finally move player
	velocity = move_and_slide(velocity, Vector3.UP) 

func _jump(delta):
	# Coyote time based jumps 
	if is_on_floor():
		coyoteTimeCounter = coyoteTime
	else:
		velocity.y -= gravity * delta # Sets gravity
		coyoteTimeCounter -= delta
	if coyoteTimeCounter > 0.0 and Input.is_action_just_pressed("jump"):
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
		
