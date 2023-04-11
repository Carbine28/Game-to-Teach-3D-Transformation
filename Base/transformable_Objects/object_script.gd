class_name  ObjectBlock
extends Spatial

signal transform_finished

enum State{ TRANSLATION, ROTATION, SCALE, PASSIVE}

var object_state

var rotation_locked: bool
var rotation_lerp = 0.0

var default_rotation
var default_position
var default_transform_basis: Basis

var current_rotation = Vector3.ZERO

var local_rotation_clockwise = Vector3.ZERO
var local_rotation_anticlockwise = Vector3.ZERO
var current_position = Vector3.ZERO
var current_scale = Vector3.ZERO

var target_rotation = Vector3.ZERO
var target_rotation_axis
var target_position = Vector3.ZERO
var final_position = Vector3.ZERO	

var target_scale = Vector3.ZERO 

var max_scale = Vector3(2,2,2)
var min_scale = Vector3(0.5, 0.5, 0.5)

func moveObject(vPosition: Vector3):
	if vPosition == Vector3.ZERO:
		target_position = current_position + vPosition
	else:
		final_position = current_position + vPosition
		target_position = current_position + vPosition + Vector3(0,0.01,0)
	object_state = State.TRANSLATION 

func rotateObject(axis: int , value: float):
	if not rotation_locked:
		rotation_locked = true
		
		target_rotation_axis = axis
		if axis == 1:
			target_rotation.y += deg2rad(value)
			local_rotation_anticlockwise.y += value
			local_rotation_clockwise.y -= value
		elif axis == 0:
			target_rotation.x += deg2rad(value)
			local_rotation_anticlockwise.x += value
			local_rotation_clockwise.x -= value
		else:
			target_rotation.z += deg2rad(value)
			local_rotation_anticlockwise.z += value
			local_rotation_clockwise.z -= value
			
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
