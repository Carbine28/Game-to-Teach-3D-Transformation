extends Spatial

# Constants
# Exported Variables
export(int) var level_id

# - Unused variables for scoring - #
export var three_star: float = 10.0 
export var two_star: float = 20.0
export var one_star: float = 30.0
# Regular Variables
var _transformGUI : Control
export var max_score: float = 0 # Score based on time , quicker the better

onready var player = $Player
#onready var _spawn = $LevelPoints/SpawnPoint

func _ready():
	instance_timer()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
func instance_timer():
	var timer:= Timer.new()
	add_child(timer)
	timer.start()
	# can also set timer interval here
	timer.connect("timeout", self,"_on_timer_timeout" )

func _on_timer_timeout() -> void:
	# Currently used to as a shortest time not score
	max_score += 1

func _on_OutofBoundsFloor_body_entered(body) -> void:
	if body.name != "Player":
		body.global_translation = body.Instance.default_position
	# Objects without gravity
