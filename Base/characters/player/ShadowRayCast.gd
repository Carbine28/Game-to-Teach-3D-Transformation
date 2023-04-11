extends RayCast

onready var _blobShadow = $"../BlobShadow"
var _player
export(float) var margin = 0.01

func _ready():
	_blobShadow.set_as_toplevel(true)
	_player = owner
	
func _process(_delta):
	handle_raycast()

func handle_raycast():
	var collider = get_collider()
	if collider:
#		print(collider.global_translation.y)
		_blobShadow.global_translation = Vector3(_player.global_translation.x, collider.global_translation.y + margin, _player.global_translation.z )
		_blobShadow.show()
				
	else:
		_blobShadow.hide()
