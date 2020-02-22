extends Button

onready var UDP_Players := get_node("../UDP_Players")
onready var Name := get_node("../Name")

func _pressed() -> void:
	if text == "cancel":
		Sound.play_sfx("res://Assets/SFX/button2.wav", 0.0, 0.5)
		if UDP_Players:
			UDP_Players.rect_size.y = 840
			UDP_Players.rect_position.y = 220
			Name.rect_position.y = 20
			UDP_Players._on_udp_data_changed()
		text = "by IP"
	else:
		Sound.play_sfx("res://Assets/SFX/button2.wav", 0.0, 2)
		if UDP_Players:
			UDP_Players.rect_size.y = 640
			UDP_Players.rect_position.y = 420
			Name.rect_position.y = 220
			UDP_Players._on_udp_data_changed()
		text = "cancel"
	$Controls.set_visible(!$Controls.is_visible())
