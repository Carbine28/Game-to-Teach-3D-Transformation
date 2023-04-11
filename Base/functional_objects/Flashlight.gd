extends KinematicBody

export(bool) var _grabbable = true
export(bool) var _selectable = true
export(int) var _durability = 300 # Durablity of flashlight (in seconds) [not used]
export(float) var gravity = 1.0

var _gravity: bool = true
var _source
var force = Vector3.ZERO

func _ready():
	if _grabbable:
		add_to_group("MOVEABLE")
	if _selectable:
		add_to_group("TRANSFORMABLE")
		
	add_to_group("FLASHLIGHT")
	_source = get_node("model/SpotLight")
	
func _process(delta):
	if _gravity:
		force.y -= delta * gravity
# warning-ignore:return_value_discarded
		move_and_collide(force)

func update_translation(var position: Vector3):
	global_translation = position
