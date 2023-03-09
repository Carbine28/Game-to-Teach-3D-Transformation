extends Panel


var translate_draggable: PackedScene = preload("res://GUI/transformableUI/TransformBlock_Modifiable.tscn")
var rotate_draggable: PackedScene = preload("res://GUI/transformableUI/RotateBlock_Modifiable.tscn")
var scale_draggable: PackedScene = preload("res://GUI/transformableUI/ScaleBlock_Modifiable.tscn")
onready var dropLocation = $Padding/DrawColumn
var idCount: int
# Block limit variables
var translation_limit: Vector3
var rotation_limit: Vector3
var root

func _ready():
	root = owner
	idCount = 0

# Test if block can be dropped
func can_drop_data(_position, data):
	var can_drop: bool = data is Node and data.is_in_group("DRAGGABLE")
	return can_drop
	
func drop_data(_position, data):
	var draggable_block : ColorRect
	if data.label == "Translate":
		draggable_block = translate_draggable.instance()
	elif data.label == "Rotate":
		draggable_block = rotate_draggable.instance()
	else:
		draggable_block = scale_draggable.instance()
	
		
	draggable_block.id = idCount
	draggable_block.label = data.label
	
#	print(draggable_block.label)
	draggable_block.block_Type = data.block_Type
	draggable_block.dropped_on_target = true
	dropLocation.add_child(draggable_block)
	configure_block_limits(draggable_block)
	idCount += 1

func set_block_limits(t_limit, r_limit):
	translation_limit = t_limit
	rotation_limit = r_limit
	
func configure_block_limits(block: ColorRect):
	# Improvement: Disable editing instead of hiding the block and inserting a locked image
	if block.label == "Translate":
		if translation_limit.x == 0:
			block.hide_input_x()
		if translation_limit.y == 0:
			block.hide_input_y()
		if translation_limit.z == 0:
			block.hide_input_z()
	# TODO Need to do rotation Axis
			
func _on_clearButton_pressed():
	idCount = 0

func _on_TransformableGUI_drawArea_block_deleted():
	idCount -= 1
