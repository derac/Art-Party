extends Button

var countdown

func _ready():
	if get_tree().is_network_server() != true:
		set_visible(false)

func _pressed():
	if get_tree().is_network_server() == true:
		Game_Server.peer.set_refuse_new_connections(true)
		rpc("start_timer")

remotesync func start_timer():
	UDP_Broadcast.broadcasting = false
	UDP_Broadcast.udp.put_var("remove")
	Sound.play_sfx("res://Sounds/Buttons/button2.wav")
	countdown = 3
	text = String(countdown)
	$Start_Timer.start()
	set_visible(true)
	grab_click_focus()
	rect_position.y = 20
	rect_size.y = 1040
	set_disabled(true)
	get_node("../Back").set_visible(false)
	get_node("../Config").set_visible(false)

func _on_Timer_timeout():
	if countdown == 3:
		Sound.play_sfx("res://Sounds/Buttons/button2.wav", 0.0, 0.75)
	if countdown == 2:
		Sound.play_sfx("res://Sounds/Buttons/button2.wav", 0.0, 0.5)
	if countdown > 1:
		countdown -= 1
		text = String(countdown)
		$Start_Timer.start()
	else:
		Game_Server.start_game()
