extends Button

func _notification(what) -> void:
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or \
		what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		toggle()

# Esc (default cancel key) to exit
func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle()

func _pressed() -> void:
	close()
	
func close() -> void:
	$Menu/Quit_Button.set_visible(false)
	$Menu/Menu_Button.set_visible(false)
	visible = false

func toggle() -> void:
	if visible:
		Sound.play_sfx("res://Assets/SFX/off.wav")
		close()
	else:
		Sound.play_sfx("res://Assets/SFX/on.wav")
		if get_tree().get_current_scene().get_name() != "Setup":
			$Menu/Menu_Button.set_visible(true)
		else:
			$Menu/Quit_Button.set_visible(true)
		visible = true
