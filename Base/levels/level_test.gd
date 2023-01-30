extends Spatial

onready var thirdPersonCamera = $Camera
onready var player = $Player
signal camera_toggled
var cameraIsActive = true
var ray_origin = Vector3()
var ray_target = Vector3()

func _ready():
	thirdPersonCamera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _physics_process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	
	if thirdPersonCamera.current:
		ray_origin = thirdPersonCamera.project_ray_origin(mouse_position)
		ray_target = ray_origin + thirdPersonCamera.project_ray_normal(mouse_position) * 2000
		
		var space_state = get_world().direct_space_state
		var intersection = space_state.intersect_ray(ray_origin, ray_target)
	
		if not intersection.empty():
			#var pos = intersection.position
			#print(intersection.collider)	
			pass	
func _process(delta):
	if Input.is_action_just_pressed("switch_camera"):
		emit_signal("camera_toggled")
		cameraIsActive = !cameraIsActive
		thirdPersonCamera.set_process(cameraIsActive) # Enable/Disable TP Camera
		if cameraIsActive:
			thirdPersonCamera.make_current()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.get_node("Camera").rotation = thirdPersonCamera.rotation # reset rotation so input matches camera
	if cameraIsActive:
		thirdPersonCamera.translation.x = player.translation.x
			
func _on_OutofBoundsFloor_body_entered(body):
	# Player 
	if body.name == "Player":
		body.global_translation = body.defaultSpawnPoint
	else: # Objects with gravity
		body.global_translation = body.owner.defaultSpawnPoint
	# Objects without gravity
