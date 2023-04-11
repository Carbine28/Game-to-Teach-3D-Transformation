extends Node

signal keys_updated(keys)

var keys_held: int 

func _ready():
	keys_held = 0
	
func get_keys_held():
	return keys_held	

func add_keys_held():
	keys_held += 1
	emit_signal("keys_updated")
	
func sub_keys_held():
	if keys_held > 0:
		keys_held -= 1
		emit_signal("keys_updated")

func _on_Key_key_obtained():
	add_keys_held()
	
