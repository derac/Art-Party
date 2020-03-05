extends CheckBox

func _toggled(button_pressed: bool) -> void:
	Sound.set_mute(button_pressed)
