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
			if get_tree().get_current_scene().get_name() in ["Play", "Lobby"]:
				if Game_Server.is_server:
					$Menu/Menu_Button.text = "end"
					$Menu/Menu_Button.set_disabled(false)
				else:
					$Menu/Menu_Button.text = "no :)"
					$Menu/Menu_Button.set_disabled(true)
			else:
				$Menu/Menu_Button.text = "menu"
				$Menu/Menu_Button.set_disabled(false)
			$Menu/Menu_Button.set_visible(true)
		else:
			$Menu/Quit_Button.set_visible(true)
		visible = true
	# Forces mouse to update >_>
	get_viewport().warp_mouse(get_viewport().get_mouse_position())

func _on_Menu_Button_pressed():
	$Menu/Quit_Button.set_visible(true)
	$Menu/Menu_Button.set_visible(false)
