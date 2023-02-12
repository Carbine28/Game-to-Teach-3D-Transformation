extends Panel

var draggable: PackedScene = preload("res://GUI/transformableUI/TransformBlock_Modifiable.tscn")
onready var dropLocation = $Padding/DrawColumn
var idCount: int

func _ready():
	idCount = 0

# Test if block can be dropped
func can_drop_data(_position, data):
	var can_drop: bool = data is Node and data.is_in_group("DRAGGABLE")
	return can_drop
	
func drop_data(_position, data):
	var draggable_block: ColorRect = draggable.instance()
	draggable_block.id = idCount
	draggable_block.label = data.label
	draggable_block.block_Type = data.block_Type
	draggable_block.dropped_on_target = true
	dropLocation.add_child(draggable_block)
	idCount += 1


func _on_clearButton_pressed():
	idCount = 0


func _on_TransformableGUI_drawArea_block_deleted():
	idCount -= 1
