extends Node

var my_name : String = ""
var external_ip := ""
var UPNP_state := "uninitialized"
# udp_data = {"PLAYER_IP": {"is_server": bool, "name": ''}}
var udp_data := {} setget udp_data_set
signal udp_data_changed
# game_state = {int network_id: {"name": '', "cards": [], "played_by": []}}
var game_state := {} setget game_state_set
signal game_state_changed

func udp_data_set(value : Dictionary) -> void:
	udp_data = value
	emit_signal("udp_data_changed")

func game_state_set(value : Dictionary) -> void:
	game_state = value
	emit_signal("game_state_changed")

func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://Assets/Images/mouse_press.png"),
								  Input.CURSOR_POINTING_HAND,
								  Vector2(36,33))
	Input.set_custom_mouse_cursor(load("res://Assets/Images/mouse.png"),
								  Input.CURSOR_ARROW,
								  Vector2(36,33))
	Input.set_custom_mouse_cursor(load("res://Assets/Images/mouse_paint.png"),
								  Input.CURSOR_CROSS,
								  Vector2(36,33))
	Input.set_custom_mouse_cursor(load("res://Assets/Images/mouse_text.png"),
								  Input.CURSOR_IBEAM,
								  Vector2(36,33))
	
	OS.set_borderless_window(true)
	OS.set_window_maximized(true)
	OS.set_window_size(OS.get_screen_size())
	OS.set_window_position(Vector2(0, 0))
	randomize()
