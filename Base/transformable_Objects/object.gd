extends RigidBody

onready var _gizmo = $gizmo
# Position Variables
export var SpawnPoint : Vector3
export var currentPosition = Vector3.ZERO
export var nextPosition = Vector3.ZERO
# Object Movement Variables
export var speed = 2
var direction
var old_parent

func _ready():
	_gizmo.visible = false
	SpawnPoint = global_translation
	currentPosition = SpawnPoint
	nextPosition = currentPosition
	add_to_group("TRANSFORMABLE")
	mode = MODE_KINEMATIC
	
func _physics_process(delta):
	if (currentPosition - nextPosition).length() > 0.1:
		direction = (nextPosition - currentPosition).normalized()
		global_translation += (direction)  * delta * speed
		
	
# warning-ignore:unused_argument
func _process(delta):
		currentPosition = global_translation
		
func moveObject(vPosition: Vector3):
	nextPosition = currentPosition + vPosition 


#func _on_Area_body_entered(body):
#	if body.is_in_group("Player"):
#		old_parent = body.get_parent()
#		old_parent.remove_child(body)
#		self.add_child(body)
#
#
#func _on_Area_body_exited(body):
#	if body.is_in_group("Player"):
#		self.remove_child(body)
#		old_parent.add_child(body)
#
