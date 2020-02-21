extends LineEdit

var address := ''

func _ready() -> void:
	connect("focus_entered", self, "_focus_entered")

func _focus_entered() -> void:
	Sound.play_sfx("res://Sounds/Buttons/on.wav", -3.0, 0.75)

func _gui_input(_event : InputEvent) -> void:
	if address != text:
		Sound.play_sfx("res://Sounds/Buttons/off.wav", -6.0, 1.5)
		address = text
		if address.find(":") > 0:
			var address_array = address.rsplit(":", true, 1)
			get_node("../Go").address["ip"] = address_array[0]
			get_node("../Go").address["port"] = address_array[1]
