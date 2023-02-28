extends Spatial


export(PackedScene) var box
export var maximum_box_stack: int
export var box_offset_distance_y: float # Sets the distance between boxes
# Regular Variables
var selectable_object
# Onready
onready var _hand_container = $HandContainer

 
func _ready():
#	_hand_container.add_child(box.instance())
	pass
	
func _input(_event):
		if Input.is_action_just_pressed("interact"):
			if selectable_object:
				print("Interactacting with object ID: " , selectable_object.object_id)
				var parent = selectable_object.get_parent()
				_hand_container.add_child(selectable_object)
				parent.remove_child(selectable_object)
				

func _on_Area_body_entered(body):

	if body.is_in_group("TRANSFORMABLE"):
		selectable_object = body
				
func _on_Area_body_exited(body):
	
	if body.is_in_group("TRANSFORMABLE") and body == selectable_object:
		selectable_object = null

