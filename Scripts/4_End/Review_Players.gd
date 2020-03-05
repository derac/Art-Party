extends Stretch_Grid

var review_button := load("res://Screens/Components/Review_Button.tscn")
# {id: score}
var scores := {}

func calculate_scores() -> void:
	var player_ids := Global.game_state.keys()
	player_ids.sort()
	for id in player_ids:
		scores[id] = 0
	for id in player_ids:
		var id_index = player_ids.find(id)
		var stack = Global.game_state[id]["cards"]
		for turn in range(2, stack.size(), 2):
			if stack[turn].length() > 3 and (stack[turn] in stack[0] or\
											 stack[0] in stack[turn]):
				scores[id] += 1
				scores[player_ids[id_index - player_ids.size() + turn - 1]] += 1
				if turn > 2:
					scores[player_ids[id_index - player_ids.size() + turn - 2]] += 1

class SortByScore:
	static func sort_descending(a, b) -> bool:
		if a[1] > b[1]:
			return true
		return false

func _ready() -> void:
	calculate_scores()
	
	var score_array := []
	for id in scores.keys():
		score_array.append([id, scores[id]])
	score_array.sort_custom(SortByScore, "sort_descending")
	
	for i in score_array.size():
		create_review_button(Global.game_state[score_array[i][0]]['name'],
							 score_array[i][0])

func create_review_button(text : String,\
						  player_id: int) -> void:
	var instance = review_button.instance()
	add_child(instance)
	instance.player_id = player_id
	instance.text = String(scores[player_id]) + " - " + text + "'s cards"
