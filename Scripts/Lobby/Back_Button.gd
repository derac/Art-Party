extends Button

var setup_screen := load("res://Screens/Setup.tscn")

func _pressed() -> void:
	get_tree().change_scene_to(setup_screen)
