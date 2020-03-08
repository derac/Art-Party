extends Button

var lobby_scene := load("res://Screens/Lobby.tscn")
var address := {}

func _ready() -> void:
	Game_Server.peer.connect("connection_succeeded", self, "_connection_succeeded")

func _pressed() -> void:
	if address.has_all(["ip", "port"]) and Global.my_name.length():
		Game_Server.start_client(address["ip"], int(address["port"]))
	else:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -3, .75)

func _connection_succeeded() -> void:
	Sound.play_sfx("res://Assets/SFX/button1.wav")
	UDP_Broadcast.broadcasting = false
	UDP_Broadcast.udp.put_var("remove")
	get_tree().change_scene_to(lobby_scene)
