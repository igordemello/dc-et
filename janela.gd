extends Control
class_name JanelaSO

@export var btn_barra : Button
@onready var btn_x : Button = $btn_x

enum state {
	closed,
	open,
	minimized
}

var current = state.open

func _ready() -> void:
	add_to_group("janelas_so")

func _process(_delta: float) -> void:
	if current == state.closed:
		btn_barra.visible = false
		visible = false
		return
	if current == state.minimized:
		btn_barra.visible = true
		visible = false
		return
	if current == state.open:
		btn_barra.visible = true
		visible = true


func _on_btn_x_pressed() -> void:
	current = state.closed


func _on_btn_redcoin_pressed() -> void:
	if current == state.minimized:
		current = state.open
	elif current == state.open:
		current = state.minimized

func _on_btn_minimized_pressed() -> void:
	current = state.minimized
