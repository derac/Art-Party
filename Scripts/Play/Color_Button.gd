extends Button

func _pressed() -> void:
	Global.color = Color(name)
	get_parent().set_visible(false)
