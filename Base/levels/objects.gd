extends Spatial

# Object script, used to assign IDs to child objects

var id_count:int = 0


func _ready():
	for child in get_children():
		child.object_id = id_count
		id_count += 1
		
