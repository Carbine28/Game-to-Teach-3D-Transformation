extends KinematicBody

export var mouse_sensitivity = 0.05
export var speed = 10
export var acceleration = 10
export var jump = 8
export var coyoteTime = 0.2
var coyoteTimeCounter = 0.0

export var gravity = 18.2


onready var _body = $Body
onready var _head = $Head

var velocity = Vector3.ZERO
var look_rotation = Vector3.ZERO
var direction = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_body.visible = false

func _physics_process(delta):
	# Sets the head(camera) rotation based on mouse movement
	_head.rotation_degrees.x = look_rotation.x
	_head.rotation_degrees.y = look_rotation.y
	# Set player movement to WASD controls, normalize and rotate so direction moved is always the camera front
	direction = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		0,
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	).normalized().rotated(Vector3.UP, _head.rotation.y)
	
	# Interpolate current velocity to desired velocity
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta) 
	velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	
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
	
	# Finally move player
	velocity = move_and_slide(velocity, Vector3.UP) 


func _input(event):
	if event is InputEventMouseMotion:
		look_rotation.x -= event.relative.y * mouse_sensitivity
		look_rotation.x = clamp(look_rotation.x, -89.0, 89.0)
		look_rotation.y -= event.relative.x * mouse_sensitivity
		look_rotation.y = wrapf(look_rotation.y, 0.0, 360.0)
