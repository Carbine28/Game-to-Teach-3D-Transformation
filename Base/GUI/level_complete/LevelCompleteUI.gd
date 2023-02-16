extends Control

onready var _World = $"../../World"
onready var _score = $Padding/VBoxContainer/scorePanel/score


func _on_level_complete():
	_score.text = "Score: " + String(_World.get_child(0).max_score)
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

# Buttons
func _on_main_menu_pressed():
	hide()
	get_tree().paused = false
	get_tree().quit()

func _on_next_level_pressed():
	hide()
	get_tree().paused = false
