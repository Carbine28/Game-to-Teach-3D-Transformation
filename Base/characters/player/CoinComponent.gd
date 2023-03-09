extends Node

var coins_held: int

func _ready():	
	coins_held = 0
	
func add_coin():
	coins_held += 1
	
func get_coins_held():
	return coins_held

