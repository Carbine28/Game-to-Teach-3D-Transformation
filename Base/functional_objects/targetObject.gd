tool
extends Spatial

signal transform_checked(status_t, status_r, status_s)

export(NodePath) var baseObjectPath
export(Resource) var baseObjectResource
export(bool) var copyMesh = false
export(bool) var setTransformToBase = false


export(Vector3) var translate_offset = Vector3.ZERO
export(bool) var add_offset = false
export(bool) var sub_offset = false
export(Vector3) var total_offset 
export(bool) var reset_offset = false

export(float, 0.5, 2, .1) var scale_modifier setget _set_scale

export(Vector3) var rotate_modifier setget _set_rotation

export(float) var distance_threshhold = 0.2 # How far two thinks are to be considered acceptable
export(float) var degree_threshold = 5.0 # Degree? / Threshold?
export(float) var scale_theshold = 0.1

export var default_color: Color = Color(1, 1, 1) 
export var highlight_color: Color = Color(1, 0, 0) 
export var hide_block: bool = false
onready var _timer = $Timer
var _completed: bool = false

var _meshInstance : MeshInstance
var base_object

var base_transform
var base_mesh_instance


func _ready():
	
	if not Engine.editor_hint:
		
		base_object = get_node(baseObjectPath)
		base_object.target_object = self
		_meshInstance = get_child(0)
		base_transform = base_object.global_transform
		# Set basis of Base Node
		global_transform.basis = base_transform.basis
		rotation_degrees += rotate_modifier
		rotate_modifier = rotation_degrees
		scale = scale * scale_modifier
		change_to_default_color()
#		# Then get Basis of MeshInstance node
#		base_mesh_instance = base_object.get_mesh_instance()
#		if base_mesh_instance:
##			_meshInstance.scale = base_mesh_instance.scale
#			pass
#		else:
#			printerr("Error in fetching base mesh instance " , base_object)
			
func _process(_delta):
	if setTransformToBase:
		if Engine.editor_hint:
			setTransformToBase = false
			base_object = get_node(baseObjectPath)
			global_translation = base_object.global_translation
	if add_offset:
		add_offset = false
		base_object = get_node(baseObjectPath)
		global_translation += translate_offset
		total_offset += translate_offset
		property_list_changed_notify ()
	if sub_offset:
		sub_offset = false
		base_object = get_node(baseObjectPath)
		global_translation -= translate_offset
		total_offset -= translate_offset
		property_list_changed_notify ()
	if reset_offset:
		reset_offset = false
		base_object = get_node(baseObjectPath)
		global_translation = base_object.global_translation
		total_offset = Vector3.ZERO
		property_list_changed_notify ()


func _on_button_pressed():
	if not _completed:
		var translation_status: bool = check_translation()
		var rotation_status: bool = check_rotation()
		var scale_status: bool = check_scale()
		if translation_status and rotation_status and scale_status:
			print("Correct")
			_completed = true
			emit_signal("transform_checked", true)
			hide()
		else:
			print("Not in place:, ", self)
			show()
			highlight_wrong_colour()
			_timer.start()
			modifiy_ui()

# Modifies icon above objects to see which are correct / wrong

func change_to_default_color():
	_meshInstance.mesh.surface_get_material(0).set_shader_param("_color", default_color)
func highlight_wrong_colour():
	_meshInstance.mesh.surface_get_material(0).set_shader_param("_color", highlight_color)
	
func modifiy_ui():
	pass
# Checks distance between target object(self) and base object is less than threshold 
func check_translation() -> bool:
	var distance = global_translation.distance_to(base_object.global_translation)
	if distance <= distance_threshhold:
#		emit_signal("transform_checked", true)
#		hide()
		return true
	else:
		return false

func check_rotation():
#	print(base_object.Instance.local_rotation_anticlockwise)
	var target_rot = rotate_modifier.y
	var base_rot = base_object.rotation_degrees.y
	
	var result_rot = abs(target_rot - base_rot)
	if result_rot <= degree_threshold:
		return true
	else:
		return false
	
func check_scale() -> bool:
	var target_scale = scale
	var base_scale = base_object.scale
	
	var result_scale = abs(target_scale.length() - base_scale.length())
	if result_scale <= scale_theshold:
		return true
	else:
		return false
	
func _set_scale(new_value:float) -> void:
	scale_modifier = new_value	
	
func _set_rotation(new_value: Vector3) -> void:
	rotate_modifier = new_value
	rotation_degrees += rotate_modifier
	property_list_changed_notify ()
	
func _on_Timer_timeout():
	change_to_default_color()
	if hide_block:
		hide()
