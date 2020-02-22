extends Button

func _pressed() -> void:
	Global.color = Color(name)
	get_node('../../Liquid').set_self_modulate(Global.color)
	get_parent().set_visible(false)
