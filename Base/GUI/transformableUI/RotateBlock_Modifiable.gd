extends ColorRect

onready var _option = $Padding/vDisplayContainer/hInputContainer/OptionButton
onready var _input = $Padding/vDisplayContainer/hInputContainer/rotInput


onready var _name = $Padding/vDisplayContainer/blockName
export var id: int
export var label:String
var block_Type

var dropped_on_target: bool = false
var inputValue
var inputOption
var defaultOption = 1

func _ready() -> void:
	add_to_group("DRAGGABLE")
	_name.text = label
	inputValue = 0
	add_Options()
	inputOption = defaultOption
	_option.selected = defaultOption
	
func add_Options():
	_option.add_item("X", 0)
	_option.add_item("Y", 1)
	_option.add_item("Z", 2)
	
func _on_deleteSelfButton_pressed():
	queue_free()
	
func _on_rotInput_input_Updated(value):
	inputValue = value

func _on_OptionButton_item_selected(index):
	inputOption = index	
