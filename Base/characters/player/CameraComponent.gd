extends Spatial

var ray_origin = Vector3()
var ray_target = Vector3()
var mouse_position
var _player
var _transformGUI
var wall_bound_collided: bool = false
var wall_z: float

onready var _camera = $"../SpringArm/Camera"


func _ready():
	_transformGUI = get_tree().get_root().get_node("Main").get_node("GUI").get_node("TransformableGUI")
	_player = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
func _physics_process(_delta):
	fire_Object_RayCast()
	
func _process(_delta):
	 pass

# Fires RayCast	towards mouse cursor
func fire_Object_RayCast():
	mouse_position = get_viewport().get_mouse_position()
	var intersection = check_for_intersection()
	
	# Ray collision found
	if not intersection.empty():
		
		if intersection.collider.is_in_group("TRANSFORMABLE"):
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			if Input.is_action_just_pressed("left_click"):
				# Pass reference to object to gui
				handle_Object(intersection.collider)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)	
								
func check_for_intersection():
	ray_origin = _camera.project_ray_origin(mouse_position)
	ray_target = ray_origin + _camera.project_ray_normal(mouse_position) * 2000
	var space_state = get_world().direct_space_state
	# Find anything that intersects with the ray
	var intersection = space_state.intersect_ray(ray_origin, ray_target)
	return intersection

# This code should be in transform gui instead or use a signal
func handle_Object(object):
	# Object
	_transformGUI.select_object(object)
	

