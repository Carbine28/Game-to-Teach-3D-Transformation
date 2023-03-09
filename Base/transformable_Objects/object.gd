class_name Block
extends KinematicBody

# Exports
export(bool) var can_translate = true
export(bool) var can_rotate
export(bool) var can_scale
export(bool) var moveable
export(bool) var transformable = true
export(Vector3) var translate_axis_limit = Vector3(1,1,1)
export(Vector3) var rotate_axis_limit = Vector3(0,1,0)
export var translation_speed: float = 4
export var rotation_speed = 0.7
export var scale_speed = 0.05
export var _max_scale = Vector3(2, 2, 2)
var object_id:int
var movable_object

# Vars
var block_type:= "NORMAL"
var Instance = ObjectBlock.new()
# Onready variables
#onready var _gizmo = $gizmo

func _ready():
	# Connect Signal To Transformable GUI . Emit a signal per action committed
	var _gui = get_tree().root.get_child(0).get_node("World/../GUI/TransformableGUI")
	Instance.connect("transform_finished", _gui, "_on_Transform_Finished")
	
#	_gizmo.set_as_toplevel(true) # Prevent rotation from affecting gizmo
#	_gizmo.visible = false # Hide Axis Gizmo
	set_instance_variables()
	if transformable:
		add_to_group("TRANSFORMABLE")
	if moveable:
		add_to_group("MOVEABLE")
	__ready()
		
func __ready():
	pass
	

func set_instance_variables():
	Instance.default_position = global_translation
	Instance.default_rotation = global_rotation
	Instance.current_position = global_translation
	Instance.current_rotation = global_rotation
	Instance.rotation_locked = false	
	Instance.target_position = Instance.current_position # not neccesary
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
		Instance.State.ROTATION:
			handle_state_rotation(delta)
		Instance.State.SCALE:
			handle_state_scale(delta)
		Instance.State.PASSIVE:
			pass
			
	
func handle_state_translation(delta):
	if (Instance.current_position - Instance.target_position).length() > 0.1:
			var direction = (Instance.target_position - Instance.current_position).normalized()
			var velocity = (direction)  * delta * translation_speed
#			global_translation += (direction)  * delta * translationSpeed
#			translation += (direction)  * delta * translation_speed
#			_gizmo.global_translation = translation
			if movable_object:
				movable_object.move_and_collide(velocity)
								
			var _collision = move_and_collide(velocity)
			
			if _collision:
				var _collider = _collision.get_collider()
#				print("Block collided with: ",  _collider)
				if _collider != movable_object:
					if _collider.name == "Player":
						translation += velocity
					else:
						Instance.object_state = Instance.State.PASSIVE
						Instance.emit_signal("transform_finished")
				else:
					move_and_slide(velocity * 0.9)
#					translation += velocity
	else:	
		translation = Instance.target_position
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
		scaleTarget =  Vector3(1, 1, 1)- scaleTarget
		scale_object_local(scaleTarget)
	
func update_translation(var position: Vector3):
	global_translation = position
	Instance.current_position = position
	
func get_transformation_permissions():
	return Vector3(can_translate, can_translate, can_translate)
func set_transformation_permissions(var permissions: Vector3):
	can_translate = permissions.x
	can_rotate = permissions.y
	can_scale = permissions.z

func get_translation_limit() -> Vector3 : 
	return translate_axis_limit
func set_translation_limit(var _limits: Vector3):
	translate_axis_limit = _limits
	
## Area on Top of object which signals the player to move differently depending on floor/platform
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Platform # Change player movement to platform type
		#print(body.floor_state)
	elif body.is_in_group("MOVEABLE"):
		if body.block_type == "PHYSICS":
			print("on")
			movable_object = body
			# Translate block slightly out of collision margin
			movable_object.translation += Vector3(0, .02, 0)
			body._gravity = false
			
func _on_Area_body_exited(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Floor # Change player movement to floor type.
	elif body == movable_object:
		body._gravity = true
		movable_object = null
		

