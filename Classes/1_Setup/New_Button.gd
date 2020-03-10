extends Button

var lobby_scene := load("res://Screens/Lobby.tscn")

func _pressed() -> void:
	if Global.my_name.length():
		Sound.play_sfx("res://Assets/SFX/button1.wav")
		var error : int = Game_Server.start_serving()
		if not error:
			error = get_tree().change_scene_to(lobby_scene)
			if error:
				print("Failed to change scene to lobby_scene")
	else:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -3, .75)
