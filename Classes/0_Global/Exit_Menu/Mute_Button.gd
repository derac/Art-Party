extends CheckBox

var mute_file := File.new()

func _ready() -> void:
	if not Log.if_error(mute_file.open("user://mute_state.txt", File.READ),
									   "Failed to open user://mute_state.txt"):
		if mute_file.get_var():
			pressed = true
	mute_file.close()

func _toggled(button_pressed: bool) -> void:
	Sound.set_mute(button_pressed)
	if not Log.if_error(mute_file.open("user://mute_state.txt", File.WRITE),
									   "Failed to open user://mute_state.txt"):
		mute_file.store_var(button_pressed)
	mute_file.close()
