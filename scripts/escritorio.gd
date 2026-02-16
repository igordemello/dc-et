extends Node3D

@onready var fps_text: Label = $CanvasLayer/fps_text

func _process(delta: float) -> void:
	fps_text.text = str(Engine.get_frames_per_second())
