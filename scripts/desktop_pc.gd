extends Control

@export var sub_viewport: SubViewport

@onready var hora: Button = $hora


func _process(_delta: float) -> void:
	var dt = Time.get_datetime_dict_from_system()
	hora.text = "%02d:%02d" % [dt.hour, dt.minute]
