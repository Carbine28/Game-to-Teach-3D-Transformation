extends LineEdit


signal input_Updated(value)

onready var LineEditRegEx = RegEx.new()
var input = ""

var defaultInput = "1"
var enableDefaultInput: bool
var hasDecimal = false

func _ready():
	 # Blocks invalid characters except numbers and decimal point
#	LineEditRegEx.compile("^[0-9.]*$")
	#^(?:[0-9]|[\.]|[\-])*$\
	LineEditRegEx.compile("^-?[0-9.]*$")

func _on_numberInput_text_changed(new_text):
	if LineEditRegEx.search(new_text):
		input = new_text		
		emit_signal("input_Updated",input)
	else:
		text = input
		caret_position = text.length()
