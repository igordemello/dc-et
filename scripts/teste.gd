extends StaticBody3D


@onready var focus_camera: Camera3D = $FocusCamera

func can_focus():
	return true

func start_focus(player):
	player.activate_focus_camera(focus_camera)
