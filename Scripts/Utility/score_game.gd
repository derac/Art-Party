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
