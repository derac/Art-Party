extends Button

var countdown : int

func _ready() -> void:
	if Game_Server.is_server != true:
		set_visible(false)

func _pressed() -> void:
	var min_players = 1 if OS.is_debug_build() else 4
	if Game_Server.is_server == true and Global.game_state.size() >= min_players:
		Game_Server.peer.set_refuse_new_connections(true)
		rpc("start_timer")
	else:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -3, .75)

remotesync func start_timer() -> void:
	UDP_Broadcast.broadcasting = false
	UDP_Broadcast.remove_self()
	Sound.play_sfx("res://Assets/SFX/button2.wav")
	countdown = 3
	if OS.is_debug_build():
		countdown = 1
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
