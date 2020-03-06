extends Control

func _ready() -> void:
	Game_Server.stop_serving()
	Game_Server.stop_client()
	UDP_Broadcast.listening = true
	UDP_Broadcast.broadcasting = true
	Sound.change_music("res://Assets/Music/menu.ogg", 0, 15)
