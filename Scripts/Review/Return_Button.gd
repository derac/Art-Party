extends Button

func _pressed():
	get_parent().set_visible(false)
	get_node('../Canvas').history = [[]]
	get_node('../Canvas').redraw()
