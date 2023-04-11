extends Control

onready var _World = $"../../World"
signal restart_pressed

func _ready():
# warning-ignore:return_value_discarded
	connect("restart_pressed", _World, "on_restart_pressed")
	
func _on_PauseMenu_hide():
	get_tree().paused = false

func _on_PauseMenu_draw():
	get_tree().paused = true

## Pause Buttons
func _on_back_button_up():
	hide()
	get_tree().paused = false

func _on_restart_button_up():
	emit_signal("restart_pressed")
	hide()

func _on_menu_button_up():
	get_tree().quit() # Exit game
