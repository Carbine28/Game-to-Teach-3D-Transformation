extends Area

signal coin_obtained

var _container

func _ready():
	_container = get_parent()
# warning-ignore:return_value_discarded
	connect("coin_obtained", _container, "_on_Coin_Obtained")


func _on_Coin_body_entered(body):
	if body.name == "Player":
		emit_signal("coin_obtained")
		queue_free()

