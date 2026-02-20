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

var backupTransformMainCam

@onready var crosshair: ColorRect = $"../CanvasLayer/crosshair"
var crosshairVisible = true

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
	
	crosshair.visible = crosshairVisible

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
			smooth_focus_transition(collider.focus_camera)

func _input(_event):
	if current_state == PlayerState.SITTING and Input.is_action_just_pressed("interact"):
		stand_up()
		cdSittingExit = timeSittingExit
		
	if current_state == PlayerState.FOCUSING and Input.is_action_just_pressed("mouse_right"):
		smooth_exit_focus()
		cdFocusExit = timeFocusExit

func sit(chair):
	if current_state != PlayerState.FREE or cdSittingExit > 0:
		return
	
	current_state = PlayerState.SITTING
	current_chair = chair
	
	velocity = Vector3.ZERO
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(
		self,
		"global_transform:origin",
		chair.seat_position.global_transform.origin,
		0.6
	)
	
	await tween.finished


func stand_up():
	if current_chair == null:
		return
	
	velocity = Vector3.ZERO
	set_physics_process(false)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(
		self,
		"global_transform:origin",
		current_chair.exit_position.global_transform.origin,
		0.6
	)
	
	await tween.finished
	
	await get_tree().process_frame
	set_physics_process(true)
	
	current_state = PlayerState.FREE
	current_chair = null


func smooth_focus_transition(target_camera: Camera3D):
	crosshairVisible = false
	
	current_state = PlayerState.FOCUSING
	active_focus_camera = target_camera
	
	backupTransformMainCam = main_camera.global_transform
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(
		main_camera,
		"global_transform",
		target_camera.global_transform,
		0.6
	)
	
	await tween.finished
	
	
	main_camera.current = false
	target_camera.current = true
	
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func smooth_exit_focus():
	if current_state != PlayerState.FOCUSING:
		return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	active_focus_camera.current = false
	main_camera.current = true
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(
		main_camera,
		"global_transform",
		backupTransformMainCam,
		0.6
	)
	
	await tween.finished
	
	current_state = PlayerState.SITTING
	active_focus_camera = null
	
	crosshairVisible = true
