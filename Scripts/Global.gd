extends Node

var Name_Generator = preload("res://Scripts/name-generator.gd")

var my_name = ""
var game_server = false

func _ready():
	OS.set_borderless_window(true)
	OS.set_window_maximized(true)
	OS.set_window_size(OS.get_screen_size())
	OS.set_window_position(Vector2(0, 0))
	
	randomize()
	my_name = Name_Generator.generate(3,5)
	
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or \
		what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		UDP_Server.udp.put_var("remove")
		print("removing")
		get_tree().quit()

# Esc (default cancel key) to exit
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		UDP_Server.udp.put_var("remove")
		print("removing")
		get_tree().quit()

#func _process(delta):
#	pass
