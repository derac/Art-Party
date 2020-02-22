extends Button

func _pressed():
	Sound.play_sfx("res://Sounds/Buttons/button1.wav", 0.0, 1.25)
	get_node('../Canvas').undo()
