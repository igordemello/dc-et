extends Camera3D

@export var max_offset := Vector2(3.0, 2.0)
@export var sensitivity := 0.002
@export var smoothness := 8.0

var target_offset := Vector2.ZERO
var current_offset := Vector2.ZERO
var base_rotation := Vector3.ZERO


@export var target_object: Node3D
@export var rotation_sensitivity := 0.5

var dragging := false

@export var zoom_step := 2.0
@export var min_fov := 25.0
@export var zoom_smoothness := 8.0
var base_fov := 0.0
var target_fov := 0.0

func _ready():
	base_rotation = rotation_degrees
	
	base_fov = fov
	target_fov = fov

func _input(event):
	if current:
		if event is InputEventMouseMotion:
			target_offset.x -= event.relative.x * sensitivity
			target_offset.y += event.relative.y * sensitivity
			
			target_offset.x = clamp(target_offset.x, -max_offset.x, max_offset.x)
			target_offset.y = clamp(target_offset.y, -max_offset.y, max_offset.y)
	
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				dragging = event.pressed
				
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed and Input.is_action_pressed("shift"):
				target_fov -= zoom_step
				target_fov = clamp(target_fov, min_fov, base_fov)
				
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed and Input.is_action_pressed("shift"):
				target_fov += zoom_step
				target_fov = clamp(target_fov, min_fov, base_fov)
		
		if event is InputEventMouseMotion and dragging:
			_rotate_object(event.relative)
			

func _rotate_object(relative: Vector2):
	if target_object == null:
		return
	
	target_object.rotate_y(deg_to_rad(-relative.x * rotation_sensitivity))
	target_object.rotate_x(deg_to_rad(-relative.y * rotation_sensitivity))

func _process(delta):
	current_offset = current_offset.lerp(target_offset, smoothness * delta)

	rotation_degrees.y = base_rotation.y + current_offset.x
	rotation_degrees.x = base_rotation.x - current_offset.y
	
	fov = lerp(fov, target_fov, zoom_smoothness * delta)
