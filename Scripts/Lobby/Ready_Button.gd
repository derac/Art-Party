extends Button

var countdown

func _pressed():
	if get_tree().is_network_server() == true:
		Game_Server.peer.set_refuse_new_connections(true)
		UDP_Server.broadcasting = false
		rpc("start_timer")

remotesync func start_timer():
	countdown = 3
	text = String(countdown)
	$Start_Timer.start()

func _on_Timer_timeout():
	if countdown > 1:
		countdown -= 1
		text = String(countdown)
		$Start_Timer.start()
	else:
		Game_Server.start_game()
