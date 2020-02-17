extends Button

func _pressed() -> void:
	if $Colors.is_visible():
		Sound.play_sfx("res://Sounds/Buttons/off.wav", 0.0, 0.8)
		$Colors.set_visible(false)
	else:
		Sound.play_sfx("res://Sounds/Buttons/on.wav", 0.0, 0.8)
		$Colors.set_visible(true)
