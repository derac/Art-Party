extends Control

func _ready() -> void:
	OS.hide_virtual_keyboard()
	Game_Server.stop_serving()
	Game_Server.stop_client()
	Broadcast.start_listening()
	Broadcast.set_broadcasting(true)
	Sound.change_music("res://Assets/Music/menu.ogg", 0, 15)
