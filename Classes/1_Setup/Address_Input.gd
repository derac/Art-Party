extends LineEdit

var error : int
var address := ''
var address_file := File.new()
onready var Go = get_node("/root/Setup/Controls/Go")

func _ready() -> void:
	error = address_file.open("user://address.txt", File.READ)
	if error:
		print("Failed to open user://address.txt")
	text = address_file.get_as_text()
	address = text
	address_file.close()
	set_Go_Button(address)
	connect("focus_entered", self, "_focus_entered")

func _focus_entered() -> void:
	Sound.play_sfx("res://Assets/SFX/off.wav", -6.0, 2.0)

func _gui_input(_event : InputEvent) -> void:
	if address != text:
		Sound.play_sfx("res://Assets/SFX/off.wav", -6.0, 2.0)
		address = text
		error = address_file.open("user://address.txt", File.WRITE)
		if error:
			print("Failed to open user://address.txt")
		address_file.store_string(text)
		address_file.close()
		set_Go_Button(address)

func set_Go_Button(value : String) -> void:
	if value.find(":") > 0:
		var address_array = value.rsplit(":", true, 1)
		Go.address["ip"] = address_array[0]
		Go.address["port"] = address_array[1]
