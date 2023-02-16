extends Spatial

var _player

func _ready():
	var model = $model
	model.visible = false
	_player = get_node("../../Player")
	_respawnPlayer()
	
func _respawnPlayer():
	print(self.global_translation)
	_player.global_translation = self.global_translation	

	
