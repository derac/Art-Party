extends CheckBox

var mute_file := File.new()

func _ready() -> void:
	mute_file.open("user://mute_state.txt", File.READ)
	if mute_file.get_var():
		pressed = true
	mute_file.close()

func _toggled(button_pressed: bool) -> void:
	Sound.set_mute(button_pressed)
	mute_file.open("user://mute_state.txt", File.WRITE)
	mute_file.store_var(button_pressed)
	mute_file.close()
