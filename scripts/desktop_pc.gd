extends Control

@export var sub_viewport: SubViewport

#@onready var hora: Button = $hora


#func _process(delta: float) -> void:
	#hora.text = str(Time.get_datetime_dict_from_system().hour) + ":" + str(Time.get_datetime_dict_from_system().minute) + ":" + str(Time.get_datetime_dict_from_system().second)
