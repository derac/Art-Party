extends Button

var lobby_scene := load("res://Screens/Lobby.tscn")

func _pressed() -> void:
	if Global.my_name.length():
		Sound.play_sfx("res://Assets/SFX/button1.wav")
		if not Log.if_error(Game_Server.start_serving(),
							"Failed to start game server."):
			Log.if_error(get_tree().change_scene_to(lobby_scene),
						 "Failed to change scene to lobby_scene")
	else:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -5, .75)
