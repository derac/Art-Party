extends Button

var countdown : int

func _ready() -> void:
	if Game_Server.is_server != true:
		set_visible(false)

func _pressed() -> void:
	if Game_Server.is_server == true:
		Game_Server.peer.set_refuse_new_connections(true)
		rpc("start_timer")

remotesync func start_timer() -> void:
	UDP_Broadcast.broadcasting = false
	UDP_Broadcast.udp.put_var("remove")
	Sound.play_sfx("res://Assets/SFX/button2.wav")
	countdown = 3
	text = String(countdown)
	$Start_Timer.start()
	set_visible(true)
	grab_click_focus()
	set_disabled(true)
	get_node("../Back").set_visible(false)
	get_node("../My_IP").set_visible(false)

func _on_Timer_timeout() -> void:
	if countdown == 3:
		Sound.play_sfx("res://Assets/SFX/button2.wav", 0.0, 0.75)
	if countdown == 2:
		Sound.play_sfx("res://Assets/SFX/button2.wav", 0.0, 0.5)
	if countdown > 1:
		countdown -= 1
		text = String(countdown)
		$Start_Timer.start()
	else:
		Game_Server.start_game()
