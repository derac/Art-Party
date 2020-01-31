extends Control

func _ready():
	Game_Server.stop_serving()
	Game_Server.stop_client()
	UDP_Server.listening = true
	UDP_Server.broadcasting = true

func _exit_tree():
	UDP_Server.listening = false
	Global.udp_data = {}
