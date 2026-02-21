extends Control

@export var sub_viewport: SubViewport

@onready var hora: Button = $task_bar/hora
@onready var task_bar: Control = $task_bar

var janela_ativa : JanelaSO = null

func _ready() -> void:
	add_to_group("desktop")
	task_bar.z_index = 1

func _process(_delta: float) -> void:
	var dt = Time.get_datetime_dict_from_system()
	hora.text = "%02d:%02d" % [dt.hour, dt.minute]


func _on_btn_win_pressed() -> void:
	var janelas = get_tree().get_nodes_in_group("janelas_so")
	
	for janela in janelas:
		if janela.current == JanelaSO.state.open:
			janela.current = JanelaSO.state.minimized

func focar_janela(janela: JanelaSO) -> void:
	var todas = get_tree().get_nodes_in_group("janelas_so")
	
	for j in todas:
		j.z_index = 0
	janela_ativa = janela
	janela.z_index = 1

func limpar_foco(janela: JanelaSO) -> void:
	if janela_ativa == janela:
		janela_ativa = null
		
	var janelas = get_tree().get_nodes_in_group("janelas_so")
	for j in janelas:
		if j.current == JanelaSO.state.open:
			focar_janela(j)
			break
