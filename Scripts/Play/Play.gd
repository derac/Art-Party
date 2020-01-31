extends Control

var turn = 0
var my_index
var player_id_list = Global.game_state.keys()

# note: may need to move this logic if I am loading the play screen
# more than once per game session
func _ready():
	player_id_list.sort()
	my_index = player_id_list.find(get_tree().get_network_unique_id())
	
	var phrases = File.new()
	phrases.open("res://Assets/phrases.txt", File.READ)
	phrases = phrases.get_as_text().split("\n")
	$Title.text = phrases[randi() % phrases.size()].capitalize()
	rpc("update_card_state", $Title.text)

remotesync func update_card_state(phrase):
	Global.game_state[get_tree().get_rpc_sender_id()]['cards'].append(phrase)
