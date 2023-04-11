extends SpringArm

export var mouse_sensitivity = 0.05
var _rotate_camera: bool
onready var _anchor_pos = $"../CameraAnchorPos"

func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_rotate_camera = true
	
func _process(_delta):
	translation = _anchor_pos.global_translation
	
func _input(event):
	
		if event is InputEventMouseMotion:
			if _rotate_camera:	
				rotation_degrees.x -= event.relative.y * mouse_sensitivity
				rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
				
				rotation_degrees.y -= event.relative.x * mouse_sensitivity
				rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
		

		if Input.is_action_just_pressed("toggle_mouse"):
			if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				_rotate_camera = false
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				_rotate_camera = true
