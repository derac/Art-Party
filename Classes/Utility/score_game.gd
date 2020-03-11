static func calculate_scores(game_state : Dictionary) -> Dictionary:
	var player_ids := game_state.keys()
	var scores := {}
	
	for id in player_ids:
		scores[id] = 0
	for id in player_ids:
		var cards = game_state[id]["cards"]
		var played_by = game_state[id]["played_by"]
		for turn in range(2, cards.size(), 2):
			if is_match(cards[0], cards[turn]):
				for i in range(1, turn + 1):
					scores[played_by[i]] += 1
	
	return scores

static func calculate_stack(game_state : Dictionary, stack_id : String) -> Dictionary:
	var player_ids := game_state.keys()
	var scores := {}
	
	for id in player_ids:
		scores[id] = 0
	var cards = game_state[stack_id]["cards"]
	var played_by = game_state[stack_id]["played_by"]
	for turn in range(2, cards.size(), 2):
		if is_match(cards[0], cards[turn]):
			for i in range(1, turn + 1):
				scores[played_by[i]] += 1
	
	return scores
	
static func is_match(a : String, b : String) -> bool:
	if abs(a.length() - b.length()) < 3 \
			and a.length() > 2 and b.length() > 2 \
			and (a in b or b in a):
		return true
	return false
