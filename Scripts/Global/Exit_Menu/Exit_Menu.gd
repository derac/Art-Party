extends CanvasLayer

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)

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
		Sound.play_sfx("res://Sounds/Buttons/off.wav")
		$Panel.set_visible(false)
	else:
		Sound.play_sfx("res://Sounds/Buttons/on.wav")
		$Panel.set_visible(true)
