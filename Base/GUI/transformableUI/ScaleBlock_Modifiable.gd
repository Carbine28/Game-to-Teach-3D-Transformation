extends ColorRect

onready var _input = $Padding/vDisplayContainer/hInputContainer/input
onready var _name = $Padding/vDisplayContainer/blockName
export var id: int
export var label:String
var block_Type


var dropped_on_target: bool = false
var inputValue

func _ready() -> void:
	add_to_group("DRAGGABLE")
	_name.text = label
	_input.text = "1.0"
	inputValue = 1

func _on_deleteSelfButton_pressed():
	queue_free()
	
func _on_input_input_Updated(value):
	inputValue = value
