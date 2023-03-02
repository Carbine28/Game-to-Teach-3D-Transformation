extends Spatial

signal block_dropped
export(PackedScene) var box
export var maximum_box_stack: int
export var box_offset_distance_y: float # Sets the distance between boxes
# Regular Variables
var selectable_object
var _is_holding_object: bool = false
var block_held
var _level
# Block Variables
var _can_translate
var _can_rotate
var _can_scale
var _has_limit
var _moveable
var translate_axis_limit 
var rotate_axis_limit 
var transform_limit
var translation_speed
var rotation_speed 
var scale_speed 
var _max_scale 
var object_id
# Onready
onready var _hand_container = $HandContainer

 
func _ready():
	_level = get_tree().root.get_child(0).get_child(0).get_child(0)
	
func _process(delta):
	if _is_holding_object:
		block_held.global_translation = _hand_container.global_translation

func _input(_event):
		if Input.is_action_just_pressed("interact"):
			if selectable_object and not _is_holding_object:
				# Copy variables here
				block_held = copy_block_info(selectable_object)
				print("Interactacting with object ID: " , selectable_object.object_id)
				var parent = selectable_object.get_parent()
				parent.remove_child(selectable_object)
				
				
				# insert model into container, based on type.
				block_held.add_to_group("MOVEABLE")
				_hand_container.add_child(block_held)
				block_held.set_instance_variables()
				_is_holding_object = true
			elif _is_holding_object:
				var boxInstance = block_held.duplicate()
				_level.get_node("Objects").add_child(boxInstance)
				
				boxInstance.global_translation = _hand_container.global_translation
				
				_is_holding_object = false
				selectable_object = null
				_hand_container.remove_child(_hand_container.get_child(0))
				
func copy_block_info(object):
	var block = object.duplicate()
	return block
# _can_translate
# _can_rotate
# _can_scale
# _has_limit
# _moveable
# translate_axis_limit 
# rotate_axis_limit 
# transform_limit
# translation_speed
# rotation_speed 
# scale_speed 
# _max_scale 
# object_id	
			
func set_block_info():
	pass
	
func _on_Area_body_entered(body):
	print(body)
	if body.is_in_group("MOVEABLE"):
		print("ye")
		selectable_object = body
				
func _on_Area_body_exited(body):
	
	if body.is_in_group("MOVEABLE") and body == selectable_object:
		selectable_object = null

