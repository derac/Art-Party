extends CheckBox

var error : int
var mute_file := File.new()

func _ready() -> void:
	error = mute_file.open("user://mute_state.txt", File.READ)
	if error:
		print("Failed to open user://mute_state.txt")
	elif mute_file.get_var():
		pressed = true
	mute_file.close()

func _toggled(button_pressed: bool) -> void:
	Sound.set_mute(button_pressed)
	error = mute_file.open("user://mute_state.txt", File.WRITE)
	if error:
		print("Failed to open user://mute_state.txt")
	else:
		mute_file.store_var(button_pressed)
	mute_file.close()
