extends Button

var lobby_scene := load("res://Screens/Lobby.tscn")
var address := {}

func _ready() -> void:
	Game_Server.peer.connect("connection_succeeded", self, "_connection_succeeded")

func _pressed() -> void:
	if address.has_all(["ip", "port"]) and Global.my_name.length():
		Log.if_error(Game_Server.start_client(address["ip"], int(address["port"])),
					 "Could not start game client at %s:%s." % [address["ip"], int(address["port"])])
	else:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -5, .75)

func _connection_succeeded() -> void:
	Game_Server.server_address = address
	Sound.play_sfx("res://Assets/SFX/button1.wav")
	Broadcast.broadcasting = false
	Broadcast.request_removal()
	Log.if_error(get_tree().change_scene_to(lobby_scene),
				 "Failed to change scene to lobby_scene")
	
