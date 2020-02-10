extends Button

var lobby_scene = load("res://Screens/Lobby.tscn")

func _pressed():
	Sound.play_sfx("res://Sounds/Buttons/button1.ogg")
	var err : int = Game_Server.start_serving(3)
	if err == OK:
		get_tree().change_scene_to(lobby_scene)

