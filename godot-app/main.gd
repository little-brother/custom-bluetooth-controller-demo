extends Node3D

var MOVEMENT_TIME = 0.5
var left_timer = 0
var right_timer = 0
var player_speed = 5

@onready var camera = $XROrigin3D/XRCamera3D

func _ready():
	OS.request_permissions()		
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		get_viewport().use_xr = true
		
	set_process_input(true)	
	
	if camera.position.x != 0 or camera.position.z != 0:
		$XROrigin3D.translate(Vector3(camera.position.x, 0, camera.position.z))

func _process(delta):
	left_timer -= delta
	right_timer -= delta
	if left_timer > 0 or right_timer > 0:
		var dir = camera.global_transform.basis.z 	
		dir.y = 0
		$XROrigin3D.translate(-dir * delta * player_speed * max(right_timer, left_timer))	

func _input(ev):	
	if Input.is_action_just_pressed("left_up"):
		left_timer = MOVEMENT_TIME
		
	if Input.is_action_just_pressed("left_down"):
		left_timer = 0		

	if Input.is_action_just_pressed("right_up"):
		right_timer = MOVEMENT_TIME
		
	if Input.is_action_just_pressed("right_down"):
		right_timer = 0		
	pass

func _on_xr_right_hand_button_pressed(name):
	right_timer = MOVEMENT_TIME

func _on_xr_left_hand_button_pressed(name):
	left_timer = MOVEMENT_TIME

func _on_area_3d_body_entered(body):
	var dir = camera.global_transform.basis.z 	
	dir.y = 0
	$XROrigin3D.translate(dir * 0.05 * player_speed)
