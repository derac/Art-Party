extends Button

#onready var UDP_Players := get_node("../UDP_Players")
onready var Controls := [get_node("/root/Setup/Information/Address"),
						 get_node("/root/Setup/Controls/Go"),
						 get_node("/root/Setup/Controls/New")]

func _pressed() -> void:
	if $By_IP_label.text == "cancel":
		Sound.play_sfx("res://Assets/SFX/button2.wav", 0.0, 0.5)
		$By_IP_label.text = "join\nby IP"
	else:
		Sound.play_sfx("res://Assets/SFX/button2.wav", 0.0, 2)
		$By_IP_label.text = "cancel"
	for control in Controls:
		control.set_visible(!control.is_visible())
