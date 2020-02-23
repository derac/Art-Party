extends Control

var review_button = load("res://Screens/Components/Review_Button.tscn")
# {id: score}
var scores := {}

func calculate_scores():
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
	static func sort_descending(a, b):
		if a[1] > b[1]:
			return true
		return false

func _ready() -> void:
	calculate_scores()
	
	var score_array := []
	for id in scores.keys():
		score_array.append([id, scores[id]])
	score_array.sort_custom(SortByScore, "sort_descending")
	
	var data := Global.game_state
	var data_keys : Array = data.keys()
	var data_size : int = data_keys.size()
	var dimensions := Vector2(0, 0)
	var label_pos := Vector2(0, 0)
	
	var cols := floor(sqrt(data_size))
	if cols > 0:
		dimensions.x = (rect_size.x - (20 * (cols - 1))) / cols
		
		for col in range(cols):
			label_pos.x = col * (dimensions.x + 20)
			var rows = cols + floor((data_size / cols) - cols)
			if col == (cols - 1):
				rows += (data_size - cols * rows)
			dimensions.y = (rect_size.y - 20 * (rows - 1)) / rows
			for row in rows:
				label_pos.y = row * (dimensions.y + 20)
				
				create_review_button(label_pos,
									 dimensions,
									 data[score_array[col*cols+row][0]]['name'],
									 score_array[col*cols+row][0])

func create_review_button(position : Vector2,\
						  size : Vector2,\
						  text : String,\
						  player_id: int) -> void:
	var instance = review_button.instance()
	add_child(instance)
	instance.set_position(position)
	instance.set_size(size)
	instance.player_id = player_id
	instance.text = String(scores[player_id]) + " - " + text + "'s cards"
