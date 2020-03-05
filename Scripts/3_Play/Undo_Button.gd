extends Button

onready var Canvas := get_node("/root/Play/Canvas")

func _pressed():
	Sound.play_sfx("res://Assets/SFX/button1.wav", 0.0, 1.25)
	Canvas.undo()
