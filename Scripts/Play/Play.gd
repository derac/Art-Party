extends Control

var my_id
var my_id_index
var turn
var max_turns
var ids = Global.game_state.keys()
var awaiting_data = false
var awaiting_end = false

# note: may need to move this logic if I am loading the play screen
# more than once per game session
func _ready():
	#Change music
	Sound.change_music("res://Sounds/Play.ogg", 25)
	Sound.play_sfx("res://Sounds/Buttons/complete.ogg", -8.0)
	
	ids.sort()
	my_id = get_tree().get_network_unique_id()
	my_id_index = ids.find(my_id)
	turn = 0
	max_turns = ids.size() - ids.size() % 2
	
	# Generate a new phrase at the start of the game
	var phrases = File.new()
	phrases.open("res://Assets/phrases.txt", File.READ)
	phrases = phrases.get_as_text().split("\n")
	$Title.text = phrases[randi() % phrases.size()].capitalize()
	
	# Send initial data
	Game_Server.rpc("send_data", $Title.text, my_id)

	Global.connect("game_state_changed", self, "_on_game_state_changed")

func _on_game_state_changed():
	if awaiting_data:
		get_card_data()
	if awaiting_end:
		for id in ids:
			if Global.game_state[id]["cards"].size() != max_turns + 1:
				return
		get_node("/root/Play/Pause/Waiting_Label").text = "All data sent"

func _on_Send_Button_button_down() -> void:
	Sound.play_sfx("res://Sounds/Buttons/on.ogg", -8.0)
	
	# Send data for current card along with the id for that card stack
	if Global.game_state[ids[my_id_index - turn]]["cards"].size() % 2:
		Game_Server.rpc("send_data", $Drawing.history, ids[my_id_index - turn])
	else:
		Game_Server.rpc("send_data", $Title.text, ids[my_id_index - turn])
	
	# Increment turn number
	turn += 1
	
	# end game
	if turn >= max_turns:
		$Pause.set_visible(true)
		get_node("/root/Play/Pause/Waiting_Label").text = "Game Over"
		awaiting_end = true
		return
		
	awaiting_data = true
	$Pause.set_visible(true)
	get_node("/root/Play/Pause/Waiting_Label").text = \
		"Waiting for " + Global.game_state[ids[my_id_index - 1]]["name"]
	get_card_data()


func get_card_data():
	var cards = Global.game_state[ids[my_id_index - turn]]["cards"]
	# Does the next card stack have the right number of cards?
	if cards.size() == turn + 1:
		# Last card was a picture
		if turn % 2:
			$Drawing.history = cards[-1]
			$Drawing.redraw()
			$Title.text = ''
			$Title.set("selecting_enabled", true)
			$Title.set("editable", true)
		# last card was a title
		else:
			$Drawing.history = [[]]
			$Drawing.redraw()
			$Title.set("selecting_enabled", false)
			$Title.set("editable", false)
			$Title.text = cards[-1]
			
		# Re-enable buttons and stuff
		awaiting_data = false
		$Pause.set_visible(false)
