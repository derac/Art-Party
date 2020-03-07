extends Stretch_Grid

const review_button = preload("res://Screens/Components/Review_Button.tscn")
const score_game = preload("res://Scripts/Utility/score_game.gd")

class Sort_ID_Score_Pairs:
	static func sort_by_score_descending(a, b) -> bool:
		if a[1] > b[1]:
			return true
		return false

func _ready() -> void:
	var scores : Dictionary = score_game.calculate_scores(Global.game_state)
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
