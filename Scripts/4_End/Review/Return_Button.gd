extends Button

func _pressed() -> void:
	Sound.play_sfx("res://Assets/SFX/button2.wav", -3.0, 0.5)
	get_parent().set_visible(false)
	get_node('../Canvas').history = [[]]
	get_node('../Canvas').redraw()
