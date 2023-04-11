extends Spatial

onready var _end = $EndPoint

func open():
	_end.emit_signal("level_completed")
