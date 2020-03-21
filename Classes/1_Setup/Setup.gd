extends Control

func _ready() -> void:
	OS.hide_virtual_keyboard()
	Game_Server.stop_serving()
	Game_Server.stop_client()
	UDP_Broadcast.start_listening()
	UDP_Broadcast.start_broadcasting()
	Sound.change_music("res://Assets/Music/menu.ogg", 0, 15)
