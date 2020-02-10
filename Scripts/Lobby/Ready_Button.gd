extends Button

var countdown

func _ready():
	if get_tree().is_network_server() != true:
		get_node("/root/Lobby_Screen/Back").rect_position = Vector2(1570, 20)
		get_node("/root/Lobby_Screen/Back").rect_size = Vector2(330, 1040)
		get_node("/root/Lobby_Screen/Start").set_visible(false)

func _pressed():
	Sound.play_sfx("res://Sounds/Buttons/button2.ogg")
	if get_tree().is_network_server() == true:
		Game_Server.peer.set_refuse_new_connections(true)
		UDP_Server.broadcasting = false
		rpc("start_timer")

remotesync func start_timer():
	countdown = 3
	text = String(countdown)
	$Start_Timer.start()
	get_node("/root/Lobby_Screen/Start").set_visible(true)
	get_node("/root/Lobby_Screen/Start").rect_position = Vector2(1570, 20)
	get_node("/root/Lobby_Screen/Start").rect_size = Vector2(330, 1040)
	get_node("/root/Lobby_Screen/Start").set_disabled(true)
	get_node("/root/Lobby_Screen/Back").set_visible(false)

func _on_Timer_timeout():
	if countdown > 1:
		countdown -= 1
		text = String(countdown)
		$Start_Timer.start()
	else:
		Game_Server.start_game()
