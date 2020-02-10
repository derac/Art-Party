extends LineEdit

func _ready():
	text = Global.my_name
	connect("focus_entered", self, "_focus_entered")

func _focus_entered():
	Sound.play_sfx("res://Sounds/Buttons/on.ogg")

func _gui_input(event):
	if Global.my_name != text:
		Sound.play_sfx("res://Sounds/Buttons/on.ogg")
		Global.my_name = text
