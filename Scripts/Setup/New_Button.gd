extends Button

var lobby_scene := load("res://Screens/Lobby.tscn")

func _pressed() -> void:
	Sound.play_sfx("res://Assets/SFX/button1.wav")
	var err : int = Game_Server.start_serving()
	if err == OK:
		get_tree().change_scene_to(lobby_scene)
