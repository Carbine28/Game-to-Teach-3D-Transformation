extends Spatial

signal level_completed
var _levelCompleteMenu

# Need to change model of end point
func _ready():
	var model = $model
	_levelCompleteMenu = get_tree().get_root().get_node("Main/GUI/LevelCompleteUI")
	var err_code = connect("level_completed", _levelCompleteMenu, "_on_level_complete")

	#model.visible = false # Visible so player can know where to go to complete level
	
func _on_Area_body_entered(body):
	if body.name == "Player":
		emit_signal("level_completed")
