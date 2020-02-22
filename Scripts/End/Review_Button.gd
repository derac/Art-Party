extends Button

var player_id

func _pressed():
	get_node('/root/End/Review').player_id = player_id
