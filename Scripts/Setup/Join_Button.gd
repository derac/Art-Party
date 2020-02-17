extends Button

var lobby_scene = load("res://Screens/Lobby.tscn")
var address = {}

func _ready():
	Game_Server.peer.connect("connection_succeeded", self, "_connection_succeeded")

func _pressed():
	if address.has_all(["ip", "port"]):
		Sound.play_sfx("res://Sounds/Buttons/button1.wav")
		Game_Server.start_client(address["ip"], int(address["port"]))

func _connection_succeeded():
	UDP_Broadcast.broadcasting = false
	UDP_Broadcast.udp.put_var("remove")
	get_tree().change_scene_to(lobby_scene)
