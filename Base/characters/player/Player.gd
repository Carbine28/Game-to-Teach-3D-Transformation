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
var snap_vector = Vector3.DOWN
var floor_state
var last_direction = Vector3.FORWARD
# Onready Variables
onready var _body = $Body
onready var _spring_arm: SpringArm = $SpringArm


func _ready():
	show()
	SpawnPoint = global_translation
#	prevDirection = _camera.rotation
	add_to_group("Player")
	floor_state = PlayerFloorState.Floor # 
	
	
func _physics_process(delta):
	# Set player movement to WASD controls, normalize and rotate so direction moved is always the camera front
	direction = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		0,
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	)
#	.normalized()
	direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
#	.rotated(Vector3.UP, _camera.rotation.y)
	
	if direction != Vector3.ZERO:
			last_direction = direction
			_body.look_at(translation + direction, Vector3.UP)
			
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
			velocity = move_and_slide(velocity, Vector3.UP )
		PlayerFloorState.Platform:
			velocity = move_and_slide_with_snap(velocity, -snap_vector , Vector3.UP, true,1, 0.785398, true)

func _process(_delta):
	pass
	
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

func change_floor_state(var _state):
	floor_state = _state
		
