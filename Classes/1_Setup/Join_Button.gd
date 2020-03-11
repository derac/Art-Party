extends Button

var lobby_scene := load("res://Screens/Lobby.tscn")
var address := {}

func _ready() -> void:
	Game_Server.peer.connect("connection_succeeded", self, "_connection_succeeded")

func _pressed() -> void:
	if address.has_all(["ip", "port"]) and Global.my_name.length():
		var error : int = Game_Server.start_client(address["ip"], int(address["port"]))
		if error:
			print("Could not start game client at %s:%s." % [address["ip"], int(address["port"])])
		elif OS.is_debug_build():
			print("Joining server at %s:%s." % [address["ip"], int(address["port"])])
	else:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -3, .75)

func _connection_succeeded() -> void:
	Game_Server.server_address = address
	Sound.play_sfx("res://Assets/SFX/button1.wav")
	UDP_Broadcast.broadcasting = false
	UDP_Broadcast.remove_self()
	var error : int = get_tree().change_scene_to(lobby_scene)
	if error:
		print("Failed to change scene to lobby_scene")
	
