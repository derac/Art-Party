extends Node

var Name_Generator := load("res://Scripts/Utility/name-generator.gd")

var my_name := ""
var color := Color("#339db5") setget color_set
signal color_changed
# udp_data = {ip: {is_server: bool, last_tick: int, name: ''}}
var udp_data := {} setget udp_data_set
signal udp_data_changed
# game_state = {network_id: {name: '', cards: []}}
var game_state := {} setget game_state_set
signal game_state_changed

func color_set(value):
	color = value
	emit_signal("color_changed")

func udp_data_set(value):
	udp_data = value
	emit_signal("udp_data_changed")

func game_state_set(value):
	game_state = value
	emit_signal("game_state_changed")

func _ready() -> void:
	OS.set_borderless_window(true)
	OS.set_window_maximized(true)
	OS.set_window_size(OS.get_screen_size())
	OS.set_window_position(Vector2(0, 0))
	
	randomize()
	my_name = Name_Generator.generate(3,7)
	
	get_tree().set_auto_accept_quit(false)

func _notification(what) -> void:
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or \
		what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		UDP_Server.udp.put_var("remove")
		get_tree().quit()

# Esc (default cancel key) to exit
func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		UDP_Server.udp.put_var("remove")
		get_tree().quit()
