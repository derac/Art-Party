extends Button

var countdown : int
var current_players : int
var play_screen := load("res://Screens/Play.tscn")

func _ready() -> void:
	if not Game_Server.is_server:
		set_visible(false)

func _pressed() -> void:
	var min_players = 1 if OS.is_debug_build() else 4
	if Game_Server.is_server and Global.game_state.size() >= min_players:
		Game_Server.peer.set_refuse_new_connections(true)
		rpc("start_timer")
	else:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -5, .75)

remotesync func start_timer() -> void:
	UDP_Broadcast.request_removal()
	UDP_Broadcast.broadcasting = false
	Sound.play_sfx("res://Assets/SFX/button2.wav")
	current_players = Global.game_state.size()
	countdown = 3
	if OS.is_debug_build():
		countdown = 1
	text = String(countdown)
	visible = true
	disabled = true
	grab_click_focus()
	$Start_Timer.start()
	get_node("../Back").set_visible(false)
	get_node("../My_IP").set_visible(false)

func _on_Timer_timeout() -> void:
	if Global.game_state.size() == current_players:
		if countdown == 3:
			Sound.play_sfx("res://Assets/SFX/button2.wav", 0.0, 0.75)
		if countdown == 2:
			Sound.play_sfx("res://Assets/SFX/button2.wav", 0.0, 0.5)
		if countdown > 1:
			countdown -= 1
			text = String(countdown)
			$Start_Timer.start()
		else:
			start_game()
	else:
		Sound.play_sfx("res://Assets/SFX/bad.wav", -5, .75)
		$Start_Timer.stop()
		get_node("../Back").set_visible(true)
		if Game_Server.is_server:
			UDP_Broadcast.start_broadcasting()
			get_node("../My_IP").set_visible(true)
			disabled = false
		else:
			visible = false
		text = "start"
		

func start_game() -> void:
	Log.if_error(get_tree().change_scene_to(play_screen),
				 "Failed to change scene to play_screen")
