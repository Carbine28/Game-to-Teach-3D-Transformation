extends Control


onready var _World = $"../../World"
onready var _transformGUI = $"../TransformableGUI"
onready var _pauseMenu = $"../PauseMenu"
onready var _levelCompleteUI = $"../LevelCompleteUI"

func _unhandled_input(event):

	if Input.is_action_just_pressed("escape"):
		if not _levelCompleteUI.visible:
			if _transformGUI.visible:
				_transformGUI.hide()
			elif not _pauseMenu.visible:
				# Show menu
				_pauseMenu.show()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				# Hide menu
				if _World.current_level.thirdPersonCamera.current:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				else:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				_pauseMenu.hide()
			
