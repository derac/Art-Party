extends Button

var lobby_scene = load("res://Screens/Lobby.tscn")
var address = {}

func _pressed():
	Sound.play_sfx("res://Sounds/Buttons/button1.ogg")
	var err = Game_Server.start_client(address["ip"], address["port"], 3)
	if err == 0:
		UDP_Server.broadcasting = false
		get_tree().change_scene_to(lobby_scene)
