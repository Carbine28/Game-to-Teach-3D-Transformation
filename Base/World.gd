extends Spatial

#var test_level = preload("res://levels/level_default.tscn").instance()
# Load levels here
var test_level = load("res://levels/level_default.tscn")
# Variables
var current_level
var next_level
var camera_State

func _ready():
	current_level = get_node("level_default")
	

func on_restart_pressed():
	# Remove current level and free from memory
	remove_child(current_level)
	current_level.queue_free()
	# Load and insert next level into "World" node
	next_level = test_level.instance()
	add_child(next_level)
	# Set Current level to be the new level inserted
	current_level = get_child(0)
