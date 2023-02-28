extends StaticBody

# Allows loaded scene/node to be referenced
export(NodePath) var target_scene
onready var scene_node = get_node(target_scene)
onready var _animPlayer = $AnimationPlayer

var bodyCounter 

func _ready():
	bodyCounter = 0

func _on_Area_body_entered(body):
	
	if body.is_in_group("Player") or body.is_in_group("TRANSFORMABLE"):
		bodyCounter += 1
		if (bodyCounter == 1): # Logic handling animation 
			_animPlayer.play("buttonHeld")
			scene_node.open()
		

func _on_Area_body_exited(body):
	if body.is_in_group("Player") or body.is_in_group("TRANSFORMABLE"):
		bodyCounter -= 1
		if not bodyCounter:
			_animPlayer.play_backwards("buttonHeld")
			scene_node.close()
