extends KinematicBody

# Signals
signal transform_finished
# Exports
export var gravity = 5
export(bool) var can_translate
export(bool) var can_rotate
export(bool) var can_scale
export(bool) var has_limit = false
export(Vector3) var translate_axis_limit = Vector3.ZERO
export(Vector3) var rotate_axis_limit = Vector3.ZERO
export var transform_limit: int = 5
export var translation_speed: float = 4
export var rotation_speed = 0.7
export var object_id:int
#
var Instance = ObjectBlock.new()
# Onready variables
onready var _gizmo = $model/gizmo


func _ready():
	# Connect Signal To Transformable GUI . Emit a signal per action committed
	var _gui = get_tree().root.get_child(0).get_node("World/../GUI/TransformableGUI")
# warning-ignore:return_value_discarded
	connect("transform_finished", _gui, "_on_Transform_Finished")
	
#	_gizmo.set_as_toplevel(true) # Prevent rotation from affecting gizmo
	_gizmo.visible = false # Hide Axis Gizmo
	
	Instance.default_position = global_translation
	Instance.default_rotation = global_rotation
	Instance.current_position = global_translation
	Instance.current_rotation = global_rotation
	Instance.rotation_locked = false	
	Instance.target_position = Instance.current_position
	Instance.object_state = Instance.State.PASSIVE
	add_to_group("TRANSFORMABLE")
	

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
			handle_state_scale()
		Instance.State.PASSIVE:
			var velocity = Vector3.ZERO
			velocity.y -= gravity * delta
			velocity = move_and_collide(velocity)
			
				
func handle_state_translation(delta):
	if (Instance.current_position - Instance.target_position).length() > 0.1:
			var direction = (Instance.target_position - Instance.current_position).normalized()
#			global_translation += (direction)  * delta * translationSpeed
			translation += (direction)  * delta * translation_speed
			_gizmo.global_translation = translation
	else:
		Instance.object_state = Instance.State.PASSIVE
		emit_signal("transform_finished")


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
		emit_signal("transform_finished")


func handle_state_scale():
	scale_object_local(Instance.target_scale)
	_gizmo.scale = Instance.target_scale # Scale gizmo relative to object
	Instance.object_state = Instance.State.PASSIVE
	emit_signal("transform_finished")	
		
							
func moveObject(vPosition: Vector3):
	Instance.target_position = Instance.current_position + vPosition
	Instance.object_state = Instance.State.TRANSLATION 
	
func rotateObject(axis: int , value: float):
	if not Instance.rotation_locked:
		Instance.rotation_locked = true
		
		Instance.target_rotation_axis = axis
		if axis == 1:
			Instance.target_rotation.y += deg2rad(value)
		elif axis == 0:
			Instance.target_rotation.x += deg2rad(value)
		else:
			Instance.target_rotation.z += deg2rad(value)
			
		Instance.rotation_lerp = 0
		Instance.object_state = Instance.State.ROTATION
		
func scaleObject(vScale: Vector3):
	Instance.target_scale = vScale
	Instance.object_state = Instance.State.SCALE


## Area on Top of object which signals the player to move differently depending on floor/platform
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Platform # Change player movement to platform type
		#print(body.floor_state)
		
		
func _on_Area_body_exited(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Floor # Change player movement to floor type.
		#print(body.floor_state)
