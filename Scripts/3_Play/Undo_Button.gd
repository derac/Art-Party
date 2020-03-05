extends Button

func _pressed():
	Sound.play_sfx("res://Assets/SFX/button1.wav", 0.0, 1.25)
	get_node('../Canvas').undo()
