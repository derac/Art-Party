extends Button

func _pressed():
	if $Colors.is_visible():
		Sound.play_sfx("res://Sounds/Buttons/off.ogg")
		$Colors.set_visible(false)
	else:
		Sound.play_sfx("res://Sounds/Buttons/on.ogg")
		$Colors.set_visible(true)
