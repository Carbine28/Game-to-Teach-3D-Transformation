extends Spatial

export(PackedScene) var box
export(PackedScene) var block1
export(PackedScene) var block2
export(PackedScene) var flashlight
export var maximum_box_stack: int
export var box_offset_distance_y: float # Sets the distance between boxes
# Regular Variables
var selectable_object
var _is_holding_object: bool = false
var object_held
var block_type
var _level

var permissions
var t_limits: Vector3
# Onready
onready var _hand_container = $HandContainer
onready var _key_component = $"../../KeyComponent"
var _player
 
func _ready():
	_player = owner
	
	_level = get_tree().root.get_child(0).get_child(0).get_child(0)
	
# warning-ignore:unused_argument
func _process(delta):
	
	if _is_holding_object:
		object_held.global_translation = _hand_container.global_translation
		

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		if selectable_object and selectable_object.is_in_group("INTERACTABLE"):
			selectable_object.interact()
		if selectable_object and selectable_object.name == "LockedDoor":
			try_unlocked_door(selectable_object)
		elif selectable_object and not _is_holding_object:
			
			if selectable_object.is_in_group("BLOCK"):
				hold_block()
				_is_holding_object = true
			elif selectable_object.is_in_group("FLASHLIGHT"):
				hold_object()
				_is_holding_object = true
				
		elif _is_holding_object:
			
			if object_held.is_in_group("BLOCK"):
				_is_holding_object = false
				drop_block()
				selectable_object = null
				_hand_container.remove_child(_hand_container.get_child(0))
				
			if object_held.is_in_group("FLASHLIGHT"):
				_is_holding_object = false
				drop_object()
				selectable_object = null
				_hand_container.remove_child(_hand_container.get_child(0))
				
func hold_object():
	var parent = selectable_object.get_parent()
	parent.remove_child(selectable_object)	
	object_held = flashlight.instance()
	object_held.gravity = 0
	_hand_container.add_child(object_held)

func drop_object():
	var object_instance
	object_instance = flashlight.instance()
	_level.add_child(object_instance)
	object_instance.update_translation(_hand_container.global_translation)
	object_instance.look_at(object_instance.translation + _player.last_direction, Vector3.UP)
	
func hold_block():
	copy_block_info(selectable_object)
#				print("Interactacting with object IawD: " , selectable_object.object_id)
	var parent = selectable_object.get_parent()
	parent.remove_child(selectable_object)
		
	if block_type == "NORMAL":
		object_held = block1.instance()
			
	elif block_type == "PHYSICS":
		object_held = block1.instance()
		object_held.has_physics = true
		object_held.assign_groups()
		object_held.gravity_accel = 0
#
	_hand_container.add_child(object_held)

func drop_block():
	var instance_type = object_held.block_type
	var box_instance
	if instance_type == "NORMAL":
		box_instance = block1.instance()
	
	elif instance_type == "PHYSICS":
		box_instance = block1.instance()
		box_instance.has_physics = true
		object_held.gravity_accel = 0.05
			
	box_instance.add_to_group("TRANSFORMABLE")
	box_instance.add_to_group("MOVEABLE")
	_level.get_node("Objects").add_child(box_instance)
	set_block_info(box_instance)
	
	
func copy_block_info(object):
	permissions = object.get_transformation_permissions()
	block_type = object.block_type
	t_limits = object.get_translation_limit()
	
func set_block_info(block):
	block.set_transformation_permissions(permissions)
	block.update_translation(_hand_container.global_translation)
	block.set_translation_limit(t_limits)

# _has_limit
# _moveable

# rotate_axis_limit 
# transform_limit
# translation_speed
# rotation_speed 
# scale_speed 
# _max_scale 
# object_id	
func try_unlocked_door(door):
	if _key_component.keys_held:
		_key_component.sub_keys_held()
		door.open_door()
		selectable_object = null
		
func _on_Area_body_entered(body):
	# Check if holding somethjing already
	# If holding something dont assign object
	if not _is_holding_object:
		if body.is_in_group("MOVEABLE"):
			selectable_object = body
		elif body.name == "LockedDoor":
			selectable_object = body
		elif body.is_in_group("INTERACTABLE"):
			selectable_object = body
				
func _on_Area_body_exited(body):
	if not _is_holding_object:
		if body.is_in_group("MOVEABLE") and body == selectable_object:
			selectable_object = null
		elif body.name == "LockedDoor":
			selectable_object = null
		elif body.is_in_group("INTERACTABLE"):
			selectable_object = null
