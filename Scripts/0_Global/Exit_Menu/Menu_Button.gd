extends Button

onready var Setup_Screen = preload("res://Screens/Setup.tscn")

func _pressed() -> void:
	Sound.play_sfx("res://Assets/SFX/button1.wav", 0.0, 0.5)
	get_tree().change_scene_to(Setup_Screen)
	get_node("../Exit_Button").set_visible(true)
	visible = false
