extends Button

var lobby_scene = load("res://Screens/Lobby.tscn")
var address = {}

func _pressed():
	if address.has_all(["ip", "port"]):
		Sound.play_sfx("res://Sounds/Buttons/button1.wav")
		var err = Game_Server.start_client(address["ip"], int(address["port"]), 3)
		if err == OK:
			print("connected to ", address)
			UDP_Server.broadcasting = false
			get_tree().change_scene_to(lobby_scene)
