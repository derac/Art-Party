extends Control

func _ready():
	Game_Server.stop_serving()
	Game_Server.stop_client()
	UDP_Server.listening = true
	UDP_Server.broadcasting = true
	Sound.change_music("res://Sounds/menu.ogg", 15)

func _exit_tree():
	UDP_Server.listening = false
	Global.udp_data = {}
