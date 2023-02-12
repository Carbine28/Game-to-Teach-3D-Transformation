extends Spatial

func _ready():
	var model = $model
	model.visible = false
	var _player = get_node("../Player")
	_player.global_translation = global_translation
	
	


	
