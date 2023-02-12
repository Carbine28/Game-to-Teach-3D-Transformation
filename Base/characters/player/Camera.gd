extends Position3D

# Get reference to the two cameras
onready var firstPersonCamera = $firstPerson
var look_rotation = Vector3.ZERO
export var mouse_sensitivity = 0.05

func _ready():
	#rotation = thirdPersonCamera.rotation
	pass

func _process(_delta):
	if firstPersonCamera.current:
		rotation_degrees.x = look_rotation.x
		rotation_degrees.y = look_rotation.y
		
func _input(event):
	if event is InputEventMouseMotion and firstPersonCamera.current:
		look_rotation.x -= event.relative.y * mouse_sensitivity
		look_rotation.x = clamp(look_rotation.x, -89.9, 89.9)
		look_rotation.y -= event.relative.x * mouse_sensitivity
		look_rotation.y = wrapf(look_rotation.y, 0.0, 360.0)

