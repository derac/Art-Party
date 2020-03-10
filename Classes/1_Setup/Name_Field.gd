extends LineEdit

var name_file := File.new()
var error : int

func _ready() -> void:
	error = name_file.open("user://player_name.txt", File.READ)
	if error:
		print("Failed to open user://player_name.txt")
	text = name_file.get_as_text()
	Global.my_name = text
	name_file.close()
	
	connect("focus_entered", self, "_focus_entered")

func _focus_entered() -> void:
	Sound.play_sfx("res://Assets/SFX/off.wav", -6.0, 1.0)

func _gui_input(_event : InputEvent) -> void:
	if Global.my_name != text:
		Sound.play_sfx("res://Assets/SFX/off.wav", -6.0, 1.0)
		Global.my_name = text
		error = name_file.open("user://player_name.txt", File.WRITE)
		if error:
			print("Failed to open user://player_name.txt")
		name_file.store_string(text)
		name_file.close()
