extends LineEdit

var address = ''

func _ready():
	connect("focus_entered", self, "_focus_entered")

func _focus_entered():
	Sound.play_sfx("res://Sounds/Buttons/on.wav", -3.0, 0.8)

func _gui_input(event):
	if address != text:
		Sound.play_sfx("res://Sounds/Buttons/off.wav", -6.0, 0.8)
		address = text
		if address.find("]") > 0:
			var address_array = address.split("]", true, 1)
			address_array[0] = address_array[0].lstrip("[")
			address_array[1] = address_array[1].lstrip(":")
			get_node("/root/Setup/By_IP/Menu/Connect").address["ip"] = address_array[0]
			get_node("/root/Setup/By_IP/Menu/Connect").address["port"] = address_array[1]
