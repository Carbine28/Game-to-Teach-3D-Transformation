extends ColorRect
class_name TransformBlockMod

enum BlockType {
	TRANSLATE,
	ROTATE,
	SCALE
}

onready var _name = $Padding/vDisplayContainer/blockName
export var id: int
export var label:String
var block_Type

var x_Value
var y_Value
var z_Value

var dropped_on_target: bool = false

func _ready() -> void:
	add_to_group("DRAGGABLE")
	_name.text = label
	x_Value = 0.0
	y_Value = 0.0
	z_Value = 0.0
	
# Deletes transform block from drawing area
func _on_deleteSelfButton_pressed():
	
	queue_free()

func _on_xInput_input_Updated(value):
	x_Value = value

func _on_yInput_input_Updated(value):
	y_Value = value

func _on_zInput_input_Updated(value):
	z_Value = value
