class_name  ObjectBlock
extends Spatial

enum State{ TRANSLATION, ROTATION, SCALE, PASSIVE}

var object_state

var rotation_locked: bool
var rotation_lerp = 0.0

var default_rotation
var default_position

var current_rotation = Vector3.ZERO
var current_position = Vector3.ZERO

var target_rotation = Vector3.ZERO
var target_rotation_axis
var target_position = Vector3.ZERO

var target_scale = Vector3.ZERO 

	
