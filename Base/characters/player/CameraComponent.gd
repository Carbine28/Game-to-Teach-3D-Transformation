extends Spatial


var ray_origin = Vector3()
var ray_target = Vector3()
var mouse_position
var _player
var _transformGUI
var wall_bound_collided: bool = false
var wall_z: float

onready var _camera = $CameraPivot/Camera


func _ready():
	_transformGUI = get_tree().get_root().get_node("Main").get_node("GUI").get_node("TransformableGUI")
	print(_transformGUI)
#	_player = owner.get_node("Player")
	_player = get_parent()
	_camera.clip_to_areas = true	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _physics_process(delta):
	fire_Object_RayCast()
	
func _process(delta):
	 check_wall_bounds()
#	_camera.translation.z = _player.translation.z
#	_camera.translation.y = _player.translation.y + 2

func check_wall_bounds():
	if wall_bound_collided:
		handle_manual_camera()
		
func handle_manual_camera():
	translation.z = wall_z
	
# Fires RayCast	towards mouse cursor
func fire_Object_RayCast():
	mouse_position = get_viewport().get_mouse_position()
	var intersection = check_for_intersection(mouse_position)
	
	# Ray collision found
	if not intersection.empty():
		
		if intersection.collider.is_in_group("TRANSFORMABLE"):
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			if Input.is_action_just_pressed("left_click"):
				# Pass reference to object to gui
				handle_Object(intersection.collider)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)	
								
func check_for_intersection(var mouse_position):
	ray_origin = _camera.project_ray_origin(mouse_position)
	ray_target = ray_origin + _camera.project_ray_normal(mouse_position) * 2000
	var space_state = get_world().direct_space_state
	# Find anything that intersects with the ray
	var intersection = space_state.intersect_ray(ray_origin, ray_target)
	return intersection
#func fire_secondary_raycast(var first_intersection, var target):
#	ray_origin = first_intersection * Vector3(1.2,1.2,1.2)
#	ray_target = ray_origin + target
#	var space_state = get_world().direct_space_state
#	# Find anything that intersects with the ray
#	var intersection = space_state.intersect_ray(ray_origin, ray_target)
#	if not intersection.empty():
#		return intersection
#	else:
#		pass
	
# This code should be in transform gui instead or use a signal
func handle_Object(object):
	# Object 
	_transformGUI.selectedObject = object
	_transformGUI.visible = true
	


func _on_Area_area_entered(area):
#	wall_z = translation.z
#	wall_bound_collided = true
	print("Bound collided!")


func _on_Area_area_exited(area):
#	wall_bound_collided = false
	print("Bound left!")
