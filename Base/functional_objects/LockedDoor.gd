extends StaticBody

onready var _door = $doorModel
onready var _col = $doorCol

func open_door():
	_door.queue_free()
	_col.queue_free()
