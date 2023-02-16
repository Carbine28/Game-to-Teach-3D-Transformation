extends Spatial

# Load levels here
var levels: Array
var level_0 = load("res://levels/level_default.tscn") # Default TEST level. Unused
var level_1 = load("res://levels/level_1.tscn")
var level_2 = load("res://levels/level_2.tscn")
# Variables
var current_level
var restarted_level
var next_level
var max_levels: int

func _ready():
	levels.push_back(level_0)
	levels.push_back(level_1)
	levels.push_back(level_2)
	max_levels = levels.size() - 1
	#add_child(level_1.instance())
	add_child(levels[1].instance())
	current_level = get_child(0)

func on_next_pressed():
	remove_child(current_level)
	next_level = levels[current_level.level_id + 1].instance()
	current_level.queue_free()
	add_child(next_level)
	current_level = get_child(0)
	
func on_restart_pressed():
	remove_child(current_level) # Remove current level
	restarted_level = levels[current_level.level_id].instance() # instance the restarted level
	# free from memory
	current_level.queue_free()
	
	add_child(restarted_level)
	# Set Current level to be the new level inserted
	current_level = get_child(0)
	
