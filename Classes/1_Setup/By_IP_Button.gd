extends Button

#onready var UDP_Players := get_node("../UDP_Players")
onready var Controls := [get_node("/root/Setup/Information/Address"),
						 get_node("/root/Setup/Controls/Go"),
						 get_node("/root/Setup/Controls/New")]

func _pressed() -> void:
	if text == "cancel":
		Sound.play_sfx("res://Assets/SFX/on.wav", -3, .5)
		text = "by IP"
	else:
		Sound.play_sfx("res://Assets/SFX/on.wav", -3, .5)
		text = "cancel"
	for control in Controls:
		control.set_visible(!control.is_visible())
