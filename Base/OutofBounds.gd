extends Area

export(NodePath) var _checkpoint_path
var checkpoint
onready var mesh = $MeshInstance

func _ready():
	mesh.hide()
	if _checkpoint_path:
		checkpoint = get_node(_checkpoint_path)
	print(checkpoint)
#	

func _on_OutofBounds_body_entered(body):
	if body.is_in_group("BLOCK"):
		body.reset_transform()
	if body.name == "Player":
		if checkpoint != null:
			body.global_translation = checkpoint.global_translation
