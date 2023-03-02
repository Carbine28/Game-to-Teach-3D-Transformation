class_name  ObjectBlock
extends Spatial

signal transform_finished

enum State{ TRANSLATION, ROTATION, SCALE, PASSIVE}

var object_state

var rotation_locked: bool
var rotation_lerp = 0.0

var default_rotation
var default_position

var current_rotation = Vector3.ZERO
var current_position = Vector3.ZERO
var current_scale = Vector3.ZERO

var target_rotation = Vector3.ZERO
var target_rotation_axis
var target_position = Vector3.ZERO

var target_scale = Vector3.ZERO 

var max_scale = Vector3(2,2,2)
var min_scale = Vector3(0.5, 0.5, 0.5)

func moveObject(vPosition: Vector3):
	target_position = current_position + vPosition
	object_state = State.TRANSLATION 

func rotateObject(axis: int , value: float):
	if not rotation_locked:
		rotation_locked = true
		
		target_rotation_axis = axis
		if axis == 1:
			target_rotation.y += deg2rad(value)
		elif axis == 0:
			target_rotation.x += deg2rad(value)
		else:
			target_rotation.z += deg2rad(value)
			
		rotation_lerp = 0
		object_state = State.ROTATION

func scaleObject(vScale: Vector3):
	if vScale.x > 1:
	
		if current_scale * vScale <= max_scale:
			
			target_scale = vScale 
			object_state = State.SCALE
		else:
			emit_signal("transform_finished")
	elif vScale.x < 1:
		if current_scale * vScale >= min_scale:
			target_scale = vScale 
			object_state = State.SCALE
		else:
			emit_signal("transform_finished") # Should emit another scale stating cannot be performed
	else:
		emit_signal("transform_finished")
