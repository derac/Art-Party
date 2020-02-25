extends Button

onready var color_picker = get_node('../../../Color_Picker')

func _pressed() -> void:
	Sound.play_sfx("res://Assets/SFX/on.wav")
	color_picker.color = Color(name)
	get_node('../../Liquid').set_self_modulate(color_picker.color)
	get_parent().set_visible(false)
