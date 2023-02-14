extends Spatial

# Need to change model of end point
func _ready():
	var model = $model
	#model.visible = false # Visible so player can know where to go to complete level
	var _player = get_node("../Player") # Need to check if player collides with collision box

func _on_Area_body_entered(body):
	if body.name == "Player":
		print_debug("Level Complete!")
