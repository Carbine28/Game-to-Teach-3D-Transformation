extends RayCast

var _player


func _ready():
	_player = owner
	
	
# warning-ignore:unused_argument
func _physics_process(delta):
	check_raycast()
	
	
func check_raycast():
	var collider = get_collider()
	if collider:
		if collider is KinematicBody:
			_player.change_floor_state(1)
		elif collider is StaticBody:
			_player.change_floor_state(0)
	
