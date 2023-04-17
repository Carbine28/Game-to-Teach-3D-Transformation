extends Control

signal next_pressed
signal restart_pressed
onready var _World = $"../../World"
onready var _score = $Padding/VBoxContainer/scorePanel/score
onready var _nextButton = $Padding/VBoxContainer/H_ButtonContainer/next_level
onready var _tGYU = $"../TransformableGUI"
var max_level

var current_level_id

func _ready():
	
# warning-ignore:return_value_discarded
	connect("restart_pressed", _World, "on_restart_pressed")
# warning-ignore:return_value_discarded
	connect("next_pressed", _World, "on_next_pressed")
	max_level = _World.level_Scenes.size() - 1
	
func _on_level_complete():
	_tGYU.hide_GUI()
	current_level_id = _World.current_level.level_id
	if current_level_id >= max_level:
		_nextButton.hide()
	else:
		_nextButton.show()
		
	_score.text = "Time: " + String(_World.get_child(0).max_score) + " s"
	show() 
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

# Buttons
func _on_main_menu_pressed():
	hide()
	get_tree().paused = false
	get_tree().quit()

func _on_next_level_pressed():
	emit_signal("next_pressed")
	get_tree().paused = false
	hide()

func _on_retry_pressed():
	emit_signal("restart_pressed")
	get_tree().paused = false
	hide()
