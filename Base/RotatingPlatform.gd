extends Spatial


export(float) var _rotate_speed = 0.5
export(bool) var lock_x = true
export(bool) var lock_y = false
export(bool) var lock_z = true

var _body

func _ready():
	_body = get_child(0)
	_body.axis_lock_motion_x = lock_x
	_body.axis_lock_motion_y = lock_y
	_body.axis_lock_motion_z = lock_z
	
	
func _process(delta):
	rotate_body(delta)

func rotate_body(delta):
	if not lock_x:
		_body.rotate_x(TAU * _rotate_speed * delta) 
	elif not lock_y:
		_body.rotate_y(TAU * _rotate_speed * delta)
	else:
		_body.rotate_z(TAU * _rotate_speed * delta)
	
