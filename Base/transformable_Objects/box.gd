extends Spatial

# Script for all moveable objects - Non gravity
var defaultSpawnPoint
# 

func _ready():
	defaultSpawnPoint = global_translation

# Each object having this script is pretty bad.
# Should use a manager instead with IDs for each object.
# Group each object into 1 group instead
# Maybe consider making a class for these transformable objects?
