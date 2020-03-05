extends LineEdit

var name_file = File.new()

func _ready() -> void:
	name_file.open("user://player_name.txt", File.READ)
	text = name_file.get_as_text()
	Global.my_name = text
	name_file.close()
	
	connect("focus_entered", self, "_focus_entered")

func _focus_entered() -> void:
	Sound.play_sfx("res://Assets/SFX/on.wav", -3.0, 0.75)

func _gui_input(_event : InputEvent) -> void:
	if Global.my_name != text:
		Sound.play_sfx("res://Assets/SFX/off.wav", -6.0, 1.0)
		Global.my_name = text
		name_file.open("user://player_name.txt", File.WRITE)
		name_file.store_string(text)
		name_file.close()
