extends Button

onready var Canvas := get_node('../../Canvas')

func _pressed() -> void:
	Sound.play_sfx("res://Assets/SFX/button2.wav", -3.0, 0.5)
	get_node('../../../Review').set_visible(false)
	Canvas.history = [[]]
	Canvas.redraw()
