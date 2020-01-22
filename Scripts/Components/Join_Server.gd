extends Button

var lobby_scene = load("res://Screens/Lobby.tscn")
var address = {}

func _ready():
	pass

func _process(_delta):
	pass

func _pressed():
	var err = Game_Server.start_client(address["ip"], address["port"], 3)
	if err == 0:
		get_tree().change_scene_to(lobby_scene)
