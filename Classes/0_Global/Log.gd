extends Node

static func if_error(error : int, message : String) -> int:
	if error:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -5, .75)
		write(message)
	return error

static func write(message : String) -> void:
	print(message)
