extends Control

var my_id : int
var my_id_index : int
var turn := 0
var max_turns : int
var ids := Global.game_state.keys()
var awaiting_next_card := false
var awaiting_end := false
var end_screen = load("res://Screens/End.tscn")

func _ready():
	Sound.change_music("res://Assets/Music/play.ogg", 25)
	Sound.play_sfx("res://Assets/SFX/complete.wav", -6.0, 0.75)
	
	ids.sort()
	my_id = get_tree().get_network_unique_id()
	my_id_index = ids.find(my_id)
	max_turns = ids.size() - ids.size() % 2
	
	# Generate a new phrase at the start of the game
	var phrases_file := File.new()
	phrases_file.open("res://Assets/Misc/phrases.txt", File.READ)
	var phrases := phrases_file.get_as_text().split("\n")
	$Title.text = phrases[randi() % phrases.size()]
	
	# Send initial data
	Game_Server.rpc("send_data", $Title.text, my_id)

	Global.connect("game_state_changed", self, "_on_game_state_changed")

func _on_game_state_changed():
	if awaiting_next_card:
		get_next_card()
	if awaiting_end:
		for id in ids:
			if !(Global.game_state[id]["cards"].size() > max_turns):
				return
		get_tree().change_scene_to(end_screen)
		

func _on_Send_Button_button_down() -> void:
	if Global.game_state[ids[my_id_index - turn]]["cards"].size() % 2:
		Game_Server.rpc("send_data", $Canvas.history, ids[my_id_index - turn])
	else:
		Game_Server.rpc("send_data", $Title.text, ids[my_id_index - turn])

	turn += 1
	
	if turn >= max_turns:
		$Pause.set_visible(true)
		Sound.play_sfx("res://Assets/SFX/complete.wav", -6.0, 0.75)
		Sound.change_music("res://Assets/Music/end.ogg", 35, -3.0)
		get_node("/root/Play/Pause/Waiting_Label").text = "waiting for game to end"
		awaiting_end = true
		_on_game_state_changed()
	else:
		awaiting_next_card = true
		$Pause.set_visible(true)
		get_next_card()
		if awaiting_next_card:
			Sound.play_sfx("res://Assets/SFX/button1.wav")
			get_node("/root/Play/Pause/Waiting_Label").text = \
				"waiting for " + Global.game_state[ids[my_id_index - 1]]["name"]


func get_next_card():
	var cards = Global.game_state[ids[my_id_index - turn]]["cards"]
	if cards.size() == turn + 1:
		Sound.play_sfx("res://Assets/SFX/button2.wav")
		# Last card was a picture
		if turn % 2:
			$Canvas.history = cards[-1]
			$Canvas.redraw()
			$Title.text = ''
			$Title.set_mouse_filter(MOUSE_FILTER_STOP)
		# last card was a title
		else:
			$Canvas.history = [[]]
			$Canvas.redraw()
			$Title.set_mouse_filter(MOUSE_FILTER_IGNORE)
			$Title.text = cards[-1]
			
		# Re-enable buttons and stuff
		awaiting_next_card = false
		$Pause.set_visible(false)
