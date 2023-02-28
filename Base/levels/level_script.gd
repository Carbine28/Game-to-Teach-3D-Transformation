extends Spatial

onready var thirdPersonCamera = $Camera
onready var player = $Player
onready var _spawn = $LevelPoints/SpawnPoint

signal camera_toggled
var cameraIsActive = true
var ray_origin = Vector3()
var ray_target = Vector3()

export var level_id:int = 1
var _transformGUI : Control
export var floorBound = -40 # Y value for player out of bounds detection

# score # - based on time, quicker the better
var max_score: float = 0 
# Current unused, compare variables with score. 3 stars is highest score. Could play animation
export var three_star: float = 10.0
export var two_star: float = 20.0
export var one_star: float = 30.0
export var cameraXOffset: float = 5.0

func _ready():
	thirdPersonCamera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_transformGUI = get_node("../../GUI/TransformableGUI")
	
func _physics_process(_delta):
	fire_Object_RayCast()
	
# Fires RayCast	towards mouse cursor
func fire_Object_RayCast():
	if thirdPersonCamera.current:
		var mouse_position = get_viewport().get_mouse_position()
		
		ray_origin = thirdPersonCamera.project_ray_origin(mouse_position)
		ray_target = ray_origin + thirdPersonCamera.project_ray_normal(mouse_position) * 2000
		var space_state = get_world().direct_space_state
		# Find anything that intersects with the ray
		var intersection = space_state.intersect_ray(ray_origin, ray_target)
		# Ray collision found
		if not intersection.empty():
			if intersection.collider.is_in_group("TRANSFORMABLE"):
				Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
				if Input.is_action_just_pressed("left_click"):
					# Pass reference to object to gui
					handle_Object(intersection.collider)
			else:
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)			

func handle_Object(object):
	# Object 
	_transformGUI.selectedObject = object
	_transformGUI.visible = true
	
func _process(_delta):
	checkForPlayer_OutofBounds()
#	if Input.is_action_just_pressed("switch_camera"):
#		emit_signal("camera_toggled")
#		cameraIsActive = !cameraIsActive
#		thirdPersonCamera.set_process(cameraIsActive) # Enable/Disable TP Camera
#		if cameraIsActive:
#			thirdPersonCamera.make_current()
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#			player.get_node("Camera").rotation = thirdPersonCamera.rotation # reset rotation so input matches camera
#	if cameraIsActive:
	thirdPersonCamera.translation.x = player.translation.x # + cameraXOffset
		
func checkForPlayer_OutofBounds():
	if player.global_translation.y < floorBound:
		_spawn._respawnPlayer()
				
func _on_OutofBoundsFloor_body_entered(body):
	
	if body.name != "Player":
		body.global_translation = body.SpawnPoint
	# Objects without gravity
	
func _on_LevelTimer_timeout():
	max_score += 0.1
