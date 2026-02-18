extends Control

@onready var label: Label = $Label

func _on_button_pressed() -> void:
	label.text = "Nice click"
	await get_tree().create_timer(2.0).timeout
	label.text = ""
