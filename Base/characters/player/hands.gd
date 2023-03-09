extends Spatial

export(PackedScene) var box
export(PackedScene) var block1
export(PackedScene) var block2
export var maximum_box_stack: int
export var box_offset_distance_y: float # Sets the distance between boxes
# Regular Variables
var selectable_object
var _is_holding_object: bool = false
var block_held
var block_type
var _level

var permissions
var t_limits: Vector3
# Onready
onready var _hand_container = $HandContainer
onready var _key_component = $"../../KeyComponent"

 
func _ready():
	_level = get_tree().root.get_child(0).get_child(0).get_child(0)
	
# warning-ignore:unused_argument
func _process(delta):
	if _is_holding_object:
		block_held.global_translation = _hand_container.global_translation

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		if selectable_object and selectable_object.name == "LockedDoor":
			try_unlocked_door(selectable_object)
		elif selectable_object and not _is_holding_object:
		
			copy_block_info(selectable_object)
#				print("Interactacting with object IawD: " , selectable_object.object_id)
			var parent = selectable_object.get_parent()
			parent.remove_child(selectable_object)
				
			if block_type == "NORMAL":
				block_held = block1.instance()
					
			elif block_type == "PHYSICS":
				block_held = block2.instance()
#
			_hand_container.add_child(block_held)
			_is_holding_object = true
		elif _is_holding_object:
			var instance_type = block_held.block_type
			var box_instance
			if instance_type == "NORMAL":
				box_instance = block1.instance()
			
			elif instance_type == "PHYSICS":
				box_instance = block2.instance()
					
			box_instance.add_to_group("TRANSFORMABLE")
			box_instance.add_to_group("MOVEABLE")
			_level.get_node("Objects").add_child(box_instance)
			set_block_info(box_instance)

				
			_is_holding_object = false
			selectable_object = null
				
			_hand_container.remove_child(_hand_container.get_child(0))
				
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
				
func _on_Area_body_exited(body):
	if not _is_holding_object:
		if body.is_in_group("MOVEABLE") and body == selectable_object:
			selectable_object = null
		elif body.name == "LockedDoor":
			selectable_object = null
	

