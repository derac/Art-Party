extends Control

var my_id : int
var my_id_index : int
var turn := 0
var max_turns : int
var ids := Global.game_state.keys()
var awaiting_next_card := false
var awaiting_end := false
onready var end_screen := preload("res://Screens/End.tscn")
onready var Title := $Controls/Title_Mask/Title

func _ready():
	Sound.change_music("res://Assets/Music/play.ogg", 25)
	Sound.play_sfx("res://Assets/SFX/complete.wav", -6.0, 0.75)
	
	ids.sort()
	my_id = get_tree().get_network_unique_id()
	my_id_index = ids.find(my_id)
	max_turns = ids.size() - ids.size() % 2
	
	print("id: ", my_id)
	print("name: ", Global.my_name)
	print("id index: ", my_id_index)
	
	# Generate a new phrase at the start of the game
	var phrases_file := File.new()
	phrases_file.open("res://Assets/Misc/phrases.txt", File.READ)
	var phrases := phrases_file.get_as_text().split("\n")
	Title.text = phrases[randi() % phrases.size()]
	
	# Send initial data
	Game_Server.rpc("send_data", Title.text, my_id)

	Global.connect("game_state_changed", self, "_on_game_state_changed")
	$Controls/Game_Timer.connect("game_timer_expired", self, "_on_game_timer_expired")

func _on_game_state_changed():
	if awaiting_next_card:
		get_next_card()
	if awaiting_end:
		for id in ids:
			if !(Global.game_state[id]["cards"].size() > max_turns):
				return
		get_tree().change_scene_to(end_screen)
		
func _on_game_timer_expired():
	if Global.game_state[ids[my_id_index - turn]]["cards"].size() % 2:
		if $Canvas.history.size() <= 1:
			$Canvas.history = [[{"color": Color(1,1,1,1), "position": Vector2(980, 512), "speed":0}], []]
			$Canvas.redraw()
	elif not Title.text:
		Title.text = Global.my_name + " timed out"
		
	_on_Send_button_down()

func _on_Send_button_down():
	if Global.game_state[ids[my_id_index - turn]]["cards"].size() % 2:
		if $Canvas.history.size() > 1:
			print(my_id, ": ", "Sending card for ", Global.game_state[ids[my_id_index - turn]]["name"], " - ", Title.text)
			Game_Server.rpc("send_data", $Canvas.history, ids[my_id_index - turn])
		else:
			Sound.play_sfx("res://Assets/SFX/off.wav", -3.0, 0.8)
			return
	else:
		if Title.text:
			print(my_id, ": ", "Sending card for ", Global.game_state[ids[my_id_index - turn]]["name"], " - ", Title.text)
			Game_Server.rpc("send_data", Title.text, ids[my_id_index - turn])
		else:
			Sound.play_sfx("res://Assets/SFX/off.wav", -3.0, 0.8)
			return

	turn += 1
	
	if turn >= max_turns:
		$Pause.set_visible(true)
		Sound.play_sfx("res://Assets/SFX/complete.wav", -6.0, 0.75)
		Sound.change_music("res://Assets/Music/end.ogg", 35, -3.0)
		get_node("/root/Play/Pause/Waiting_Label").text = "waiting for game to end"
		$Controls/Game_Timer.stop()
		awaiting_end = true
		_on_game_state_changed()
	else:
		print(my_id, " : ", Global.my_name, " - Awaiting the stack of ", Global.game_state[ids[my_id_index - turn]]["name"])
		awaiting_next_card = true
		$Pause.set_visible(true)
		get_next_card()
		if awaiting_next_card:
			Sound.play_sfx("res://Assets/SFX/button1.wav")
			$Game_Timer.stop()

func get_next_card():
	var cards = Global.game_state[ids[my_id_index - turn]]["cards"]
	if cards.size() == turn + 1:
		Sound.play_sfx("res://Assets/SFX/button2.wav")
		# Last card was a picture
		if turn % 2:
			$Canvas.history = cards[-1]
			$Canvas.redraw()
			Title.text = ''
			Title.set_editable(true)
			Title.set_mouse_filter(MOUSE_FILTER_STOP)
			$Canvas.set_mouse_filter(MOUSE_FILTER_IGNORE)
		# last card was a title
		else:
			$Canvas.history = [[]]
			$Canvas.redraw()
			Title.set_mouse_filter(MOUSE_FILTER_IGNORE)
			$Canvas.set_mouse_filter(MOUSE_FILTER_STOP)
			Title.set_editable(false)
			Title.text = cards[-1]
			
		# Re-enable buttons and stuff
		awaiting_next_card = false
		$Pause.set_visible(false)
		$Controls/Game_Timer.reset()
	else:
		update_waiting_label()

func update_waiting_label() -> void:
	var player_offset : int = Global.game_state[ids[my_id_index - turn]]["cards"].size() - 1
	$Pause/Waiting_Label.text = "waiting for " + Global.game_state[ids[(my_id_index - turn + player_offset) % ids.size()]]["name"]
