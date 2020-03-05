extends Button

var color := Color("#339db5") setget set_color

func set_color(value : Color) -> void:
	color = value
	$Liquid.set_self_modulate(color)

func _pressed() -> void:
	if $Colors.is_visible():
		Sound.play_sfx("res://Assets/SFX/off.wav", 0.0, 0.8)
		$Colors.set_visible(false)
	else:
		Sound.play_sfx("res://Assets/SFX/on.wav", 0.0, 0.8)
		$Colors.set_visible(true)
