extends Spatial


#var level_0 = load("res://levels/level_default.tscn") # Default TEST level. Unused
# Exported Variables
export var debug: bool
export(PackedScene) var debug_level 
export(Array, PackedScene) var level_Scenes

# Variables
var current_level
var restarted_level
var next_level
var highest_level: int
onready var _transform_gui = $"../GUI/TransformableGUI"

# Built in virtual methods
func _ready():
	
	if debug:
		add_child(debug_level.instance()) 
		
	else:
		# load first level atm. Will add menu as first scene to load
		add_child(level_Scenes[0].instance())
		
	current_level = get_child(0)


func on_next_pressed():
   
	remove_child(current_level)
	next_level = level_Scenes[current_level.level_id + 1].instance()
	current_level.queue_free()
	add_child(next_level)
	current_level = get_child(0)

#func reset_matrix():
#	_transform_gui._matrixPanel.null_matrix()
#
func on_restart_pressed():
#	reset_matrix()
	remove_child(current_level) # Remove current level
	if debug:
		restarted_level = debug_level.instance()
	else:
		restarted_level = level_Scenes[current_level.level_id].instance() # instance the restarted level
	# free from memory
	current_level.queue_free()

	add_child(restarted_level)
	# Set Current level to be the new level inserted
	current_level = get_child(0)
	
