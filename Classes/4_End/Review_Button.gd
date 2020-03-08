extends Button

var player_id : int

func _pressed() -> void:
	get_node('/root/End/Review').player_id = player_id
