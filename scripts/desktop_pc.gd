extends Control

@export var sub_viewport: SubViewport

@onready var hora: Button = $hora


func _process(_delta: float) -> void:
	var dt = Time.get_datetime_dict_from_system()
	hora.text = "%02d:%02d" % [dt.hour, dt.minute]


func _on_btn_win_pressed() -> void:
	var janelas = get_tree().get_nodes_in_group("janelas_so")
	
	for janela in janelas:
		if janela.current == JanelaSO.state.open:
			janela.current = JanelaSO.state.minimized
