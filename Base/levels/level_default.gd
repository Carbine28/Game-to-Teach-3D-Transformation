extends Spatial

onready var thirdPersonCamera = $Camera
onready var player = $Player

signal camera_toggled
var cameraIsActive = true
var ray_origin = Vector3()
var ray_target = Vector3()

var _transformGUI : Control

func _ready():
	thirdPersonCamera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_transformGUI = get_node("../Level_GUI/TransformableGUI")
	
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
			if Input.is_action_just_pressed("left_click"):
				if intersection.collider.is_in_group("TRANSFORMABLE"):
					# Pass reference to object to gui
					handle_Object(intersection.collider)
					

func handle_Object(object):
	# Object 
	_transformGUI.selectedObject = object
	_transformGUI.visible = true
	
func _process(delta):
	if Input.is_action_just_pressed("switch_camera"):
		emit_signal("camera_toggled")
		cameraIsActive = !cameraIsActive
		thirdPersonCamera.set_process(cameraIsActive) # Enable/Disable TP Camera
		if cameraIsActive:
			thirdPersonCamera.make_current()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.get_node("Camera").rotation = thirdPersonCamera.rotation # reset rotation so input matches camera
	if cameraIsActive:
		thirdPersonCamera.translation.x = player.translation.x
			
func _on_OutofBoundsFloor_body_entered(body):
	# Player 
	if body.name == "Player":
		body.global_translation = body.SpawnPoint
	else: # Objects with gravity
		body.global_translation = body.SpawnPoint
	# Objects without gravity
