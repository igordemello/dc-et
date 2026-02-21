extends Control
class_name JanelaSO

@export var btn_barra : Button
@onready var btn_x : Button = $btn_x

enum state {
	closed,
	open,
	minimized
}

var current = state.minimized

var desktop = null

func _ready() -> void:
	add_to_group("janelas_so")
	
	if btn_barra:
		btn_barra.pressed.connect(_on_btn_barra_pressed)
		

func _process(_delta: float) -> void:
	if desktop == null:
		desktop = get_tree().get_first_node_in_group("desktop")
	
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
	desktop.limpar_foco(self)
	current = state.closed
	


func _on_btn_barra_pressed() -> void:
	if current == state.minimized:
		current = state.open
		desktop.focar_janela(self)
		return
	
	if desktop.janela_ativa == self:
		current = state.minimized
		desktop.limpar_foco(self)
	else:
		desktop.focar_janela(self)
		

func _on_btn_minimized_pressed() -> void:
	desktop.limpar_foco(self)
	current = state.minimized
