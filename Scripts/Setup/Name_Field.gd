extends LineEdit

func _ready():
	text = Global.my_name
	connect("focus_entered", self, "_focus_entered")

func _focus_entered():
	Sound.play_sfx("res://Sounds/Buttons/on.wav", -3.0, 0.8)

func _gui_input(event):
	if Global.my_name != text:
		Sound.play_sfx("res://Sounds/Buttons/off.wav", -6.0, 0.8)
		Global.my_name = text
