extends Button

var start_screen := load("res://Screens/Start.tscn")

func _pressed() -> void:
	get_tree().change_scene_to(start_screen)
