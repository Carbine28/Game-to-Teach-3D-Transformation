extends StaticBody

onready var _animPlayer = $AnimationPlayer
export var useAnim: bool = true

func open():
	if useAnim:
		_animPlayer.play("doorRaise")
	else:
		hide()
		
func close():
	if useAnim:
		_animPlayer.play_backwards("doorRaise")
	else:
		show()
