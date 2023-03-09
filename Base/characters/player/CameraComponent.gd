extends Spatial


var ray_origin = Vector3()
var ray_target = Vector3()
var _player
var _transformGUI

onready var _camera = $CameraPivot/Camera


func _ready():
	_transformGUI = get_tree().get_root().get_node("Main").get_node("GUI").get_node("TransformableGUI")
	print(_transformGUI)
#	_player = owner.get_node("Player")
	_player = get_parent()	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _physics_process(delta):
	fire_Object_RayCast()
	
func _process(delta):
	pass
#	_camera.translation.z = _player.translation.z
#	_camera.translation.y = _player.translation.y + 2

# Fires RayCast	towards mouse cursor
func fire_Object_RayCast():
	var mouse_position = get_viewport().get_mouse_position()
	
	ray_origin = _camera.project_ray_origin(mouse_position)
	ray_target = ray_origin + _camera.project_ray_normal(mouse_position) * 2000
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

# This code should be in transform gui instead.
func handle_Object(object):
	# Object 
	_transformGUI.selectedObject = object
	_transformGUI.visible = true
	
