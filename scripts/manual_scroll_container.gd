extends ScrollContainer


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if Input.is_key_pressed(KEY_SHIFT):
				accept_event()
