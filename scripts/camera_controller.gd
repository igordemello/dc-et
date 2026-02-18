class_name CameraController
extends Node3D

@export var player_controller: PlayerController
var input_rotation: Vector3
var mouse_input: Vector2


@export_range(0.0005, 0.02, 0.0005)
var mouse_sensitivity: float = 0.005

@export var smoothing: float = 15.0

var use_interpolation: bool = false
var circle_strafe: bool = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if player_controller.current_state == player_controller.PlayerState.FOCUSING:
		return
	if event is InputEventMouseMotion:
		mouse_input.x += -event.screen_relative.x * mouse_sensitivity
		mouse_input.y += -event.screen_relative.y * mouse_sensitivity 

func _process(_delta: float) -> void:
	if player_controller.current_state == player_controller.PlayerState.FOCUSING:
		return
	
	#input_rotation.x = clampf(input_rotation.x + mouse_input.y, deg_to_rad(-90), deg_to_rad(85))
	#input_rotation.y += mouse_input.x
	
	input_rotation.x = clampf(lerp(input_rotation.x, input_rotation.x + mouse_input.y, smoothing * _delta),deg_to_rad(-90),deg_to_rad(85))
	
	input_rotation.y = lerp(input_rotation.y, input_rotation.y + mouse_input.x, smoothing * _delta)
	
	#tentativa de limitar a rotação sentado
	#if player_controller.current_state == player_controller.PlayerState.SITTING:
		#input_rotation.y = clampf(input_rotation.y + mouse_input.x, deg_to_rad(-90), deg_to_rad(85))
	#else:
		#input_rotation.y += mouse_input.x
	
	player_controller.camera_controller_anchor.transform.basis = Basis.from_euler(Vector3(input_rotation.x, 0.0, 0.0))
	
	player_controller.global_transform.basis = Basis.from_euler(Vector3(0.0, input_rotation.y, 0.0))
	
	global_transform = player_controller.camera_controller_anchor.get_global_transform_interpolated()
	
	mouse_input = Vector2.ZERO
