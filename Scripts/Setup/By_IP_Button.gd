extends Button

onready var UDP_Players = get_node("../UDP_Players")
onready var Name = get_node("../Name")

func _pressed():
	if text == "cancel":
		if UDP_Players:
			UDP_Players.rect_size.y = 840
			UDP_Players.rect_position.y = 220
			Name.rect_position.y = 20
			UDP_Players._on_udp_data_changed()
		text = "by IP"
	else:
		if UDP_Players:
			UDP_Players.rect_size.y = 640
			UDP_Players.rect_position.y = 420
			Name.rect_position.y = 220
			UDP_Players._on_udp_data_changed()
		text = "cancel"
	#block.set_visible(!block.is_visible())
	$Menu.set_visible(!$Menu.is_visible())
