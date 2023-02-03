extends Spatial

var test_level = preload("res://levels/level_default.tscn").instance()

func _ready():
	pass
	# print_debug(get_tree()) # gets the entire scene tree
	# print_debug(get_tree().get_root()) # root node is main? since root node is main
	#call_deferred("add_child", test_level) # defer code so that when main is finished setting up , 

func _unhandled_input(_event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("debug_button"):
		pass
	
			
