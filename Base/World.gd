extends Spatial

var test_level = preload("res://levels/level_test.tscn").instance()

func _ready():
	print_debug("hey")
	# print_debug(get_tree()) # gets the entire scene tree
	# print_debug(get_tree().get_root()) # root node is main? since root node is main
	call_deferred("add_child", test_level) # defer code so that when main is finished setting up , 


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
