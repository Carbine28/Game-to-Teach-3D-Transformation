extends Block
signal block_collasped

var gravity = Vector3.ZERO
var _gravity: bool = true

onready var _timer = $CollaspeTimer
export var transform_limit: int = 1 # Can only transform once
export var gravity_accel: float = 0.05
export var gravity_y_cap: float = 1


func __ready():
	var _gui = get_tree().root.get_child(0).get_node("World/../GUI/TransformableGUI")
	connect("block_collasped", _gui, "_on_Block_Collasped")
	block_type == "COLLASPE"
	
func check_collaspable_limit():
	transform_limit -= 1
	if not transform_limit:
		collaspe_block()
	
func collaspe_block():
	emit_signal("block_collasped")
	# Could Start gravity here if needed	
	_timer.start()	
	
func _on_Timer_timeout():
	
	queue_free() 	


func handle_state_transforms(delta):
	Instance.current_position = global_translation
	match Instance.object_state:
		Instance.State.TRANSLATION:
			handle_state_translation(delta)
			gravity.y = gravity_accel
		Instance.State.ROTATION:
			handle_state_rotation(delta)
			gravity.y = gravity_accel
		Instance.State.SCALE:
			handle_state_scale(delta)
			gravity.y = gravity_accel
		Instance.State.PASSIVE:
			if _gravity:
				gravity.y -= (gravity_accel * delta)
				move_and_collide(gravity)
			
func handle_state_translation(delta):
	if (Instance.current_position - Instance.target_position).length() > 0.1:
			var direction = (Instance.target_position - Instance.current_position).normalized()
			var velocity = (direction)  * delta * translation_speed

			if movable_object:
				movable_object.move_and_collide(velocity)
#				movable_object.translation += velocity
								
			var _collision = move_and_collide(velocity)
			
			if _collision:
				var _collider = _collision.get_collider()
#				print("Block collided with: ",  _collider)
				if _collider != movable_object:
					if _collider.name == "Player":
						translation += velocity
					else:
						Instance.object_state = Instance.State.PASSIVE
						check_collaspable_limit()
				else:
					move_and_slide(velocity )
#					translation += velocity
					
	else:
		translation = Instance.target_position
		Instance.object_state = Instance.State.PASSIVE
		check_collaspable_limit()
		

func handle_state_rotation(delta):
	if Instance.rotation_lerp < 1:
		Instance.rotation_lerp += delta * rotation_speed
	elif Instance.rotation_lerp > 1:
		Instance.rotation_lerp = 1
	match Instance.target_rotation_axis:
		0:	
			if rotation.x == Instance.target_rotation.x:
				Instance.rotation_lerp = 1
			else:
				rotation.x = lerp_angle(rotation.x, Instance.target_rotation.x, Instance.rotation_lerp )
		1:
			if rotation.y == Instance.target_rotation.y:
				Instance.rotation_lerp = 1
			else:
				rotation.y = lerp_angle(rotation.y, Instance.target_rotation.y, Instance.rotation_lerp )
		2:
			if rotation.z == Instance.target_rotation.z:
				Instance.rotation_lerp = 1
			else:
				rotation.z = lerp_angle(rotation.z, Instance.target_rotation.z, Instance.rotation_lerp )
	if Instance.rotation_lerp == 1:
		rotation = Instance.target_rotation
		Instance.object_state = Instance.State.PASSIVE
		Instance.rotation_locked = false
		check_collaspable_limit()

func handle_state_scale(delta):
	if Instance.target_scale >= Instance.current_scale:
		scale_expand(delta)
	else:
		scale_shrink(delta)
	
func scale_expand(delta):
	if scale >= Instance.target_scale:
		scale = Instance.target_scale
		Instance.object_state = Instance.State.PASSIVE
		Instance.current_scale = scale
		check_collaspable_limit()
	else:
		var scaleTarget = Instance.target_scale * 0.8 * delta
		scaleTarget = Vector3(1,1,1) + scaleTarget
		scale_object_local(scaleTarget)
	
func scale_shrink(delta):
	if scale <= Instance.target_scale * Instance.current_scale:
		scale = Instance.target_scale * Instance.current_scale
		Instance.object_state = Instance.State.PASSIVE
		Instance.current_scale = scale
		check_collaspable_limit()	
	else:
		var scaleTarget =  Instance.target_scale * 0.8 * delta
		scaleTarget =  Vector3(1, 1, 1)- scaleTarget
		scale_object_local(scaleTarget)	

## Area on Top of object which signals the player to move differently depending on floor/platform
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Platform # Change player movement to platform type
		#print(body.floor_state)
	elif body.is_in_group("MOVEABLE"):
		if body.block_type == "PHYSICS":
			print("on")
			movable_object = body
			# Translate block slightly out of collision margin
			movable_object.translation += Vector3(0, .02, 0)
			body._gravity = false

func _on_Area_body_exited(body):
	if body.name == "Player":
		body.floor_state = body.PlayerFloorState.Floor # Change player movement to floor type.
	elif body == movable_object:
		body._gravity = true
		movable_object = null


