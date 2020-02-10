extends Button

var setup_screen := load("res://Screens/Setup.tscn")

func _pressed() -> void:
	Sound.play_sfx("res://Sounds/Buttons/button1.wav", 0.0, 0.5)
	get_tree().change_scene_to(setup_screen)
