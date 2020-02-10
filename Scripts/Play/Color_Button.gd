extends Button

func _pressed():
	Global.color = Color(name)
	get_parent().set_visible(false)
