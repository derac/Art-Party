extends Control

var my_id : int
var my_id_index : int
var current_stack_id : int
var ids := Global.game_state.keys()

var turn := 0
var max_turns : int = ids.size() - ids.size() % 2
var awaiting_next_card := false
var awaiting_end := false

onready var end_screen := preload("res://Screens/End.tscn")
onready var Title := $Controls/Title_Mask/Title

func _ready():
	$my_name_test.text = Global.my_name
	
	Sound.change_music("res://Assets/Music/play.ogg", 0, 25)
	Sound.play_sfx("res://Assets/SFX/complete.wav", -6.0, 0.75)
	
	ids.sort()
	my_id = get_tree().get_network_unique_id()
	my_id_index = ids.find(my_id)
	current_stack_id = my_id
	
	var words_file := File.new()
	words_file.open("res://Assets/Misc/words.txt", File.READ)
	var words := words_file.get_as_text().split("\n")
	Title.text = words[randi() % words.size()]
	Game_Server.rpc("send_data", Title.text, my_id)

	Global.connect("game_state_changed", self, "_on_game_state_changed")

func _on_game_state_changed():
	if awaiting_next_card:
		get_next_card()
	if awaiting_end:
		for id in ids:
			if !(Global.game_state[id]["cards"].size() > max_turns):
				return
		get_tree().change_scene_to(end_screen)
		
func _on_Game_Timer_expired():
	if Global.game_state[current_stack_id]["cards"].size() % 2:
		if $Canvas.history.size() <= 1:
			var history_file := File.new()
			history_file.open("res://Assets/Misc/AFK_History.txt", File.READ)
			$Canvas.history = history_file.get_var()
			$Canvas.redraw()
	elif not Title.text:
		Title.text = "I am AFK :|"
		
	_on_Send_button_down()

func _on_Send_button_down():
	if Global.game_state[current_stack_id]["cards"].size() % 2:
		if $Canvas.history.size() > 1:
			Game_Server.rpc("send_data", $Canvas.history, current_stack_id)
		else:
			Sound.play_sfx("res://Assets/SFX/off.wav", -3, 0.8)
			return
	else:
		if Title.text:
			Game_Server.rpc("send_data", Title.text, current_stack_id)
		else:
			Sound.play_sfx("res://Assets/SFX/off.wav", -3, 0.8)
			return

	turn += 1
	current_stack_id = ids[my_id_index - turn]
	
	if turn >= max_turns:
		$Pause.set_visible(true)
		Sound.play_sfx("res://Assets/SFX/complete.wav", -6, 0.75)
		Sound.change_music("res://Assets/Music/end.ogg", -6, 35)
		get_node("/root/Play/Pause/Waiting_Label").text = "waiting for game to end"
		$Controls/Game_Timer.stop()
		awaiting_end = true
		_on_game_state_changed()
	else:
		awaiting_next_card = true
		$Pause.set_visible(true)
		get_next_card()
		if awaiting_next_card:
			Sound.play_sfx("res://Assets/SFX/button1.wav")
			$Controls/Game_Timer.stop()

func get_next_card():
	var cards = Global.game_state[current_stack_id]["cards"]
	if cards.size() == turn + 1:
		Sound.play_sfx("res://Assets/SFX/button2.wav")
		if turn % 2:
			$Canvas.history = cards[-1]
			$Canvas.redraw()
			Title.text = ''
			Title.set_editable(true)
			Title.set_mouse_filter(MOUSE_FILTER_STOP)
			$Canvas.set_mouse_filter(MOUSE_FILTER_IGNORE)
		else:
			$Canvas.history = [[]]
			$Canvas.redraw()
			Title.set_mouse_filter(MOUSE_FILTER_IGNORE)
			$Canvas.set_mouse_filter(MOUSE_FILTER_STOP)
			Title.set_editable(false)
			Title.text = cards[-1]
			
		awaiting_next_card = false
		$Pause.set_visible(false)
		$Controls/Game_Timer.reset()
	else:
		update_waiting_label()

func update_waiting_label() -> void:
	var player_offset : int = Global.game_state[current_stack_id]["cards"].size() - 1
	var player_name : String = Global.game_state[ids[(my_id_index - turn + player_offset) % ids.size()]]["name"]
	$Pause/Waiting_Label.text = "waiting for " + player_name
