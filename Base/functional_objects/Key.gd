extends StaticBody


signal key_obtained

var _player

func _ready():
	_player = owner.get_node("Player")
# warning-ignore:return_value_discarded
	connect("key_obtained", _player.get_node("KeyComponent"), "_on_Key_key_obtained")

func _on_Area_body_entered(body):
	if body.name == "Player":
		emit_signal("key_obtained")
		queue_free()
