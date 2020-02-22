extends LineEdit

func _ready() -> void:
	text = Global.my_name
	connect("focus_entered", self, "_focus_entered")

func _focus_entered() -> void:
	Sound.play_sfx("res://Assets/SFX/on.wav", -3.0, 0.75)

func _gui_input(_event : InputEvent) -> void:
	if Global.my_name != text:
		Sound.play_sfx("res://Assets/SFX/off.wav", -6.0, 1.0)
		Global.my_name = text
