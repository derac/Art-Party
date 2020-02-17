extends Button

var lobby_scene = load("res://Screens/Lobby.tscn")
var address = {}

func _pressed():
	if address.has_all(["ip", "port"]):
		Sound.play_sfx("res://Sounds/Buttons/button1.wav")
		var err = Game_Server.start_client(address["ip"], int(address["port"]))
		if err == OK:
			UDP_Broadcast.broadcasting = false
			UDP_Broadcast.udp.put_var("remove")
			get_tree().change_scene_to(lobby_scene)
