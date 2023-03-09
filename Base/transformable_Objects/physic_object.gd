extends Block


# Onready variables
#onready var _gizmo = 5$model/gizmo
var parent
export var gravity_accel: float = 0.05
export var gravity_y_cap: float = 1
var gravity = Vector3.ZERO
var _gravity: bool = true

func __ready():
	parent = get_parent()
	block_type = "PHYSICS"

# Overrides
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Platform # Change player movement to platform type

func _on_Area_body_exited(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Floor # Change player movement to floor type.
	
func handle_state_transforms(delta):
	Instance.current_position = global_translation
	match Instance.object_state:
		Instance.State.TRANSLATION:
			handle_state_translation(delta)
			gravity.y = gravity_accel
		Instance.State.ROTATION:
			handle_state_rotation(delta)
			gravity.y = gravity_accel
		Instance.State.SCALE:
			handle_state_scale(delta)
			gravity.y = gravity_accel
		Instance.State.PASSIVE:
			if _gravity:
				gravity.y -= (gravity_accel * delta)
				move_and_collide(gravity)
