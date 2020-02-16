extends Button

onready var block = get_node("/root/Setup/Block")

func _pressed():
	if text == "Cancel":
		text = "By IP"
	else:
		text = "Cancel"
	block.set_visible(!block.is_visible())
	$Menu.set_visible(!$Menu.is_visible())
