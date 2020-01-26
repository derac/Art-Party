extends Button

func _pressed():
	for child in get_children():
		if child.is_visible():
			child.set_visible(false)
		else:
			child.set_visible(true)
