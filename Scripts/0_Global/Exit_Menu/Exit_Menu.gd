extends CanvasLayer

func _notification(what) -> void:
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or \
		what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		toggle_panel()

# Esc (default cancel key) to exit
func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_panel()

func toggle_panel() -> void:
	if $Panel.is_visible():
		Sound.play_sfx("res://Assets/SFX/off.wav")
		$Panel.set_visible(false)
		$Panel/Menu/Exit_Button.set_visible(false)
		$Panel/Menu/Menu_Button.set_visible(false)
	else:
		Sound.play_sfx("res://Assets/SFX/on.wav")
		if get_tree().get_current_scene().get_name() != "Setup":
			$Panel/Menu/Menu_Button.set_visible(true)
		else:
			$Panel/Menu/Exit_Button.set_visible(true)
		$Panel.set_visible(true)
