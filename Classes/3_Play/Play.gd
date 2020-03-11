extends Control

var current_stack_id : String
var my_id : String
var my_id_index : int
var ids := Global.game_state.keys()

var turn := 0
var max_turns : int = ids.size() - ids.size() % 2
var awaiting_next_card := false
var awaiting_end := false

const end_screen := preload("res://Screens/End.tscn")
onready var Title := $Controls/Title_Mask/Title

func _ready():
	if OS.is_debug_build():
		$Name_Debug.set_visible(true)
		$Name_Debug.text = Global.my_name
	
	Sound.change_music("res://Assets/Music/play.ogg", 0, 25)
	Sound.play_sfx("res://Assets/SFX/complete.wav", -8, .75)
	
	ids.sort()
	my_id = OS.get_unique_id()
	my_id_index = ids.find(my_id)
	current_stack_id = my_id
	
	var words_file := File.new()
	Log.if_error(words_file.open("res://Assets/Misc/words.txt", File.READ),
				 "Failed to open res://Assets/Misc/words.txt")
	var words := words_file.get_as_text().split("\n")
	Title.text = words[randi() % words.size()]
	Game_Server.rpc("send_data", Title.text, my_id, my_id)
	
	Global.connect("game_state_changed", self, "_on_game_state_changed")

func _on_game_state_changed():
	if awaiting_next_card:
		get_next_card()
	if awaiting_end:
		for id in ids:
			if !(Global.game_state[id]["cards"].size() > max_turns):
				return
		Log.if_error(get_tree().change_scene_to(end_screen),
					 "Failed to change scene to end_screen")
		
func _on_Game_Timer_expired():
	if Global.game_state[current_stack_id]["cards"].size() % 2:
		if $Canvas.history.size() <= 1:
			$Canvas.history = [[{"speed": 0, "position": Vector2(960, 540), "color":Color("#000000")}],[]]
			$Canvas.redraw()
	elif not Title.text:
		Title.text = "I am AFK :|"
		
	_on_Send_button_down()

func _on_Send_button_down():
	if Global.game_state[current_stack_id]["cards"].size() % 2:
		if $Canvas.history.size() > 1:
			Game_Server.rpc("send_data", $Canvas.history, current_stack_id, my_id)
		else:
			Sound.play_sfx("res://Assets/SFX/off.wav", -3, .8)
			return
	else:
		if Title.text:
			Game_Server.rpc("send_data", Title.text, current_stack_id, my_id)
		else:
			Sound.play_sfx("res://Assets/SFX/off.wav", -3, .8)
			return

	turn += 1
	current_stack_id = ids[my_id_index - turn]
	
	if turn >= max_turns:
		$Pause.set_visible(true)
		Sound.play_sfx("res://Assets/SFX/complete.wav", -8, .75)
		Sound.change_music("res://Assets/Music/end.ogg", -5, 35)
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
	var player_doing : String = "draw" if Global.game_state[current_stack_id]["cards"].size() % 2 else "guess"
	$Pause/Waiting_Label.text = "waiting for %s to %s" % [player_name, player_doing]
