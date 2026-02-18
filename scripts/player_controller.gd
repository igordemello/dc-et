class_name PlayerController
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera_controller_anchor: Marker3D = $CameraControllerAnchor

enum PlayerState {
	FREE,
	SITTING,
	FOCUSING
}

var current_state: PlayerState = PlayerState.FREE
var current_chair: Node3D = null

@onready var raycast: RayCast3D = $CameraControllerAnchor/RayCast3D

var cdSittingExit := 0.0
const timeSittingExit := 1.0 #second 

var cdFocusExit := 0.0
const timeFocusExit := 1.0 #second 

var focused_object: Node3D = null
var focus_original_transform: Transform3D

@onready var main_camera: Camera3D = $CameraController/Camera3D
var active_focus_camera: Camera3D = null

func _physics_process(delta: float) -> void:
	if current_state == PlayerState.SITTING or current_state == PlayerState.FOCUSING:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("mov_left", "mov_right", "mov_front", "mov_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	if cdSittingExit > 0:
		cdSittingExit -= delta
		
	if cdFocusExit > 0:
		cdFocusExit -= delta
	
	check_interaction()

func check_interaction():
	if not raycast.is_colliding():
		return
	
	var collider = raycast.get_collider()
	
	if collider == null:
		return
	
	if collider.has_method("interact"):
		if Input.is_action_just_pressed("interact"):
			collider.interact(self)
			
	if collider.has_method("can_focus") and current_state == PlayerState.SITTING and cdFocusExit <= 0:
		if Input.is_action_just_pressed("mouse_right"):
			activate_focus_camera(collider.focus_camera)


func sit(chair):
	if current_state != PlayerState.FREE or cdSittingExit > 0:
		return
	
	current_state = PlayerState.SITTING
	current_chair = chair
	
	global_transform.origin = chair.seat_position.global_transform.origin
	velocity = Vector3.ZERO

func _input(_event):
	if current_state == PlayerState.SITTING and Input.is_action_just_pressed("interact"):
		stand_up()
		cdSittingExit = timeSittingExit
		
	if current_state == PlayerState.FOCUSING and Input.is_action_just_pressed("mouse_right"):
		exit_focus()
		cdFocusExit = timeFocusExit


func stand_up():
	if current_chair == null:
		return
	
	velocity = Vector3.ZERO
	set_physics_process(false)
	global_transform = current_chair.exit_position.global_transform
	await get_tree().process_frame
	set_physics_process(true)
	
	current_state = PlayerState.FREE
	current_chair = null


func activate_focus_camera(focus_cam: Camera3D):
	if current_state != PlayerState.SITTING:
		return
	
	current_state = PlayerState.FOCUSING
	active_focus_camera = focus_cam
	
	main_camera.current = false
	focus_cam.current = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func exit_focus():
	if current_state != PlayerState.FOCUSING:
		return
	
	if active_focus_camera:
		active_focus_camera.current = false
	
	main_camera.current = true
	
	current_state = PlayerState.SITTING
	focused_object = null
	active_focus_camera = null
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
