extends ColorRect
class_name TransformBlockMod

onready var _input_x = $Padding/vDisplayContainer/hInputContainer/xInput
onready var _input_y = $Padding/vDisplayContainer/hInputContainer/yInput
onready var _input_z = $Padding/vDisplayContainer/hInputContainer/zInput

onready var _name = $Padding/vDisplayContainer/blockName
export var id: int
export var label:String
export var enableDefault: bool
var block_Type

var x_Value
var y_Value
var z_Value

var dropped_on_target: bool = false

func _ready() -> void:
	add_to_group("DRAGGABLE")
	_name.text = label
	if enableDefault:
		_input_x.text = "1.0"
		_input_y.text = "1.0"
		_input_z.text = "1.0"
		x_Value = 1
		y_Value = 1
		z_Value = 1
	else:
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
