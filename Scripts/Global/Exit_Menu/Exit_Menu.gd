extends CanvasLayer

func _ready():
	get_tree().set_auto_accept_quit(false)

func _notification(what) -> void:
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or \
		what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		UDP_Server.udp.put_var("remove")
		get_tree().quit()

# Esc (default cancel key) to exit
func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		if $Panel.is_visible():
			Sound.play_sfx("res://Sounds/Buttons/off.ogg")
			$Panel.set_visible(false)
		else:
			Sound.play_sfx("res://Sounds/Buttons/on.ogg")
			$Panel.set_visible(true)
