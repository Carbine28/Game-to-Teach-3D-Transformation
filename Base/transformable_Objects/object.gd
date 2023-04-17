
extends KinematicBody
class_name Block


export(PackedScene) var _gizmo
# Exports variables
export(bool) var has_physics = false # Handles gravity
export(bool) var can_translate = true # Allows usage of translation block
export(bool) var can_rotate # Allows usage of rotation block
export(bool) var can_scale # Allows uage of scale block
export(bool) var moveable # Can be interacted with and picked up by player
export(bool) var transformable = true # Controls if object can be selected with mouse
export(Vector3) var translate_axis_limit = Vector3(1,1,1) # Sets translation axis limits
export(Vector3) var rotate_axis_limit = Vector3(0,1,0) # Sets rotation axis limits
export var translation_speed: float = 4 # Defines speed of translation operation
export var rotation_speed = 0.7 # Defines speed of rotation 
export var scale_speed = 0.05 # Defines speed of scaling
export var _max_scale = Vector3(2, 2, 2) # Defines max scaling of object
export var default_color: Color = Color(1,0.63,0) # default colour of object
export var highlight_color: Color = Color(0, .69, 1) # colour of object when selected

var object_id:int 
var movable_object # Used for other objects placed on top of itself

# Vars
var block_type:= "NORMAL"
var Instance = ObjectBlock.new()
# Onready variables
#onready var _gizmo = $gizmo
var _mesh_instance
var _mesh
var _material


var parent
export var gravity_accel: float = 0.05
var gravity = Vector3.ZERO
var has_gravity: bool = false
var target_object

func _ready():
	if _gizmo:
		var gizmo_instance = _gizmo.instance()
		add_child(gizmo_instance)
	load_mesh()
	# Connect Signal To Transformable GUI . Emit a signal per action committed
	var _gui = get_tree().root.get_child(0).get_node("World/../GUI/TransformableGUI")
	Instance.connect("transform_finished", _gui, "_on_Transform_Finished")
	
	add_to_group("BLOCK")
	set_instance_variables()
	assign_groups()
		
	__ready() # Overide ready function for inherited classes
		
func __ready():
	pass
	

func set_instance_variables():
	Instance.default_transform_basis = global_transform.basis 
	Instance.default_position = global_translation
	Instance.default_rotation = global_rotation
	Instance.current_position = global_translation
	Instance.current_rotation = global_rotation
	Instance.rotation_locked = false	
	Instance.target_position = Instance.current_position # not neccesary
	Instance.target_rotation = global_rotation
	Instance.object_state = Instance.State.PASSIVE
	Instance.current_scale = scale
	Instance.max_scale = _max_scale
	
func _process(delta):
	handle_state_transforms(delta)		
		
func handle_state_transforms(delta):
	Instance.current_position = global_translation
	match Instance.object_state:
		Instance.State.TRANSLATION:
			handle_state_translation(delta)
			gravity.y = gravity_accel
		Instance.State.ROTATION:
			handle_state_rotation(delta)
			gravity.y = gravity_accel
		Instance.State.SCALE:
			handle_state_scale(delta)
			gravity.y = gravity_accel
		Instance.State.PASSIVE:
			if has_gravity:
				gravity.y -= (gravity_accel * delta)
				move_and_collide(gravity)
			
	
func handle_state_translation(delta):
	if (Instance.current_position - Instance.target_position).length() > 0.1:
			var direction = (Instance.target_position - Instance.current_position).normalized()
			var velocity = (direction)  * delta * translation_speed
			if movable_object:
				movable_object.move_and_collide(velocity)
								
			var _collision = move_and_collide(velocity)
			
			if _collision:
				var _collider = _collision.get_collider()
				if _collider != movable_object:
					if _collider.name == "Player":
						translation += velocity
					else:
						Instance.object_state = Instance.State.PASSIVE
						Instance.emit_signal("transform_finished")
				else:
					move_and_slide(velocity * 0.9)
	else:	
		translation = Instance.final_position
		Instance.object_state = Instance.State.PASSIVE
		Instance.emit_signal("transform_finished")


func handle_state_rotation(delta):
	if Instance.rotation_lerp < 1:
		Instance.rotation_lerp += delta * rotation_speed
	elif Instance.rotation_lerp > 1:
		Instance.rotation_lerp = 1
		
	match Instance.target_rotation_axis:
		0:	
			if rotation.x == Instance.target_rotation.x:
				Instance.rotation_lerp = 1
			else:
				rotation.x = lerp_angle(rotation.x, Instance.target_rotation.x, Instance.rotation_lerp )
		1:
			if rotation.y == Instance.target_rotation.y:
				Instance.rotation_lerp = 1
			else:
				rotation.y = lerp_angle(rotation.y, Instance.target_rotation.y, Instance.rotation_lerp )
		2:
			if rotation.z == Instance.target_rotation.z:
				Instance.rotation_lerp = 1
			else:
				rotation.z = lerp_angle(rotation.z, Instance.target_rotation.z, Instance.rotation_lerp )
	if Instance.rotation_lerp == 1:
		rotation = Instance.target_rotation
		Instance.object_state = Instance.State.PASSIVE
		Instance.rotation_locked = false
		Instance.emit_signal("transform_finished")

func handle_state_scale(delta):
	if Instance.target_scale >= Instance.current_scale:
		scale_expand(delta)
	else:
		scale_shrink(delta)
	#	_gizmo.scale = Instance.target_scale # Scale gizmo relative to object

func scale_expand(delta):
	if scale >= Instance.target_scale:
		scale = Instance.target_scale
		Instance.object_state = Instance.State.PASSIVE
		Instance.current_scale = scale
		Instance.emit_signal("transform_finished")	
	else:
		var scaleTarget = Instance.target_scale * 0.8 * delta
		scaleTarget = Vector3(1,1,1) + scaleTarget
		scale_object_local(scaleTarget)
	
func scale_shrink(delta):
	if scale <= Instance.target_scale * Instance.current_scale:
		scale = Instance.target_scale * Instance.current_scale
		Instance.object_state = Instance.State.PASSIVE
		Instance.current_scale = scale
		Instance.emit_signal("transform_finished")	
	else:
		var scaleTarget =  Instance.target_scale * 0.8 * delta
		scaleTarget =  Vector3(1, 1, 1) - scaleTarget
		scale_object_local(scaleTarget)
	
func update_translation(var position: Vector3):
	global_translation = position
	Instance.current_position = position
	
func get_transformation_permissions():
	return Vector3(can_translate, can_rotate, can_scale)
func set_transformation_permissions(var permissions: Vector3):
	can_translate = permissions.x
	can_rotate = permissions.y
	can_scale = permissions.z

func get_translation_limit() -> Vector3 : 
	return translate_axis_limit
func set_translation_limit(var _limits: Vector3):
	translate_axis_limit = _limits
	
# Finds MeshInstance node in children	
func load_mesh():
	_mesh_instance = get_node_or_null("model/MeshInstance")
	# If not found, go through children nodes to find mesh instance
	if _mesh_instance == null:
		for child in get_children():
			if child as MeshInstance:
				_mesh_instance = child
	if  _mesh_instance:
		_material = get_material()
		if _material:
			set_default_material_color(default_color)
		else:
			pass
			
# Changes material colour of object
func set_default_material_color(var color: Color):
	_material.set_shader_param("block_color", color)
	
func highlight_mesh_color(var color: Color):
	if _material:
		_material.set_shader_param("block_color", color)
	
func get_mesh_instance() -> MeshInstance:
	var mesh_instance = get_node_or_null("model/MeshInstance")
	if mesh_instance:
		return mesh_instance
	else:
		return null
func get_mesh() -> Mesh:
	return _mesh_instance.mesh
func get_material() -> Material:
	var mesh = get_mesh()
	if not mesh:
		return null
	else:
		var material = mesh.surface_get_material(0)
		if not material:
			return null
		else:
			return material
	
	
func assign_groups():
	if has_physics:
		block_type = "PHYSICS"
		add_to_group("PHYSICS")
		has_gravity = true
	else:
		block_type = "NORMAL"
		
	if transformable:
		add_to_group("TRANSFORMABLE")
	if moveable:
		add_to_group("MOVEABLE")
		
		
func reset_transform():
	print("Transform reset")
	Instance.object_state = Instance.State.PASSIVE
	Instance.emit_signal("transform_finished")
	global_transform.basis = Instance.default_transform_basis
	global_translation = Instance.default_position
## Area on Top of object which signals the player to move differently depending on floor/platform
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Platform # Change player movement to platform type
		print(body.floor_state)
	elif body.is_in_group("MOVEABLE"):
		if body.is_in_group("BLOCK"):
			if body.is_in_group("PHYSICS"):
				movable_object = body
				# Translate block slightly out of collision margin
				movable_object.translation += Vector3(0, .02, 0)
#				body.has_gravity = false
#		elif body.is_in_group("FLASHLIGHT"):
#			print("body on object")
#			movable_object = body
#			# Translate block slightly out of collision margin
#			movable_object.translation += Vector3(0, .02, 0)
##			body.has_gravity = false
			
func _on_Area_body_exited(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Floor # Change player movement to floor type.
	elif body == movable_object:
		body.has_gravity = true
		movable_object = null
		

