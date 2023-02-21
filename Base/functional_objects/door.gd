extends StaticBody

onready var _animPlayer = $AnimationPlayer
export var useAnim: bool = true

func open():
	if useAnim:
		_animPlayer.play("doorOpen")
	else:
		hide()
		
func close():
	if useAnim:
		_animPlayer.play_backwards("doorOpen")
	else:
		show()
