extends Button

var lobby_scene = preload("res://Screens/Lobby.tscn")

func _process(_delta):
	if is_hovered():
		$multiline.set("custom_colors/font_color", Color("#5f9448"))
		$multiline.set("custom_colors/font_color_shadow", Color("#5f9448"))
	else:
		$multiline.set("custom_colors/font_color", Color("#99c24e"))
		$multiline.set("custom_colors/font_color_shadow", Color("#99c24e"))

func _pressed():
	var err : int = Game_Server.start_serving(3)
	if err == OK:
		UDP_Server.stop_listening()
		get_tree().change_scene_to(lobby_scene)

