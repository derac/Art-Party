extends Stretch_Grid

var review_button := load("res://Screens/Components/Review_Button.tscn")
# {id: score}
var scores := {}

static func calculate_scores(game_state : Dictionary) -> Dictionary:
	var player_ids := game_state.keys()
	var scores := {}
	
	for id in player_ids:
		scores[id] = 0
	for id in player_ids:
		var id_index = player_ids.find(id)
		var stack = game_state[id]["cards"]
		
		for turn in range(2, stack.size(), 2):
			if is_match(stack[0], stack[turn]):
				var played_by = game_state[id]["played_by"]
				for i in range(1, turn + 1):
					scores[played_by[i]] += 1
	
	return scores

static func is_match(a : String, b : String) -> bool:
	if abs(a.length() - b.length()) < 3 \
			and a.length() > 3 and b.length() > 3 \
			and (a in b or b in a):
		return true
	return false

class Sort_ID_Score_Pairs:
	static func sort_by_score_descending(a, b) -> bool:
		if a[1] > b[1]:
			return true
		return false

func _ready() -> void:
	var scores := calculate_scores(Global.game_state)
	
	var score_array := []
	for id in scores.keys():
		score_array.append([id, scores[id]])
	score_array.sort_custom(Sort_ID_Score_Pairs, "sort_by_score_descending")
	
	for i in score_array.size():
		create_review_button(Global.game_state[score_array[i][0]]['name'],
							 score_array[i][0],
							 scores[score_array[i][0]])

func create_review_button(player_name : String,
						  player_id: int,
						  score: int) -> void:
	var instance = review_button.instance()
	add_child(instance)
	instance.player_id = player_id
	instance.text = String(score) + " - " + player_name
