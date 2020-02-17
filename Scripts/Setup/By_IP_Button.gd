extends Button

onready var UDP_Players = get_node("/root/Setup/UDP_Players")

func _pressed():
	if text == "cancel":
		if UDP_Players:
			UDP_Players.rect_size = Vector2(1490,840)
			UDP_Players.rect_position = Vector2(20,220)
			UDP_Players._on_udp_data_changed()
		text = "by IP"
	else:
		if UDP_Players:
			UDP_Players.rect_size = Vector2(1490,640)
			UDP_Players.rect_position = Vector2(20,420)
			UDP_Players._on_udp_data_changed()
		text = "cancel"
	#block.set_visible(!block.is_visible())
	$Menu.set_visible(!$Menu.is_visible())
