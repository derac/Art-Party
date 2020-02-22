extends Control

var review_button = load("res://Screens/Components/Review_Button.tscn")

func _ready() -> void:
	Global.connect("game_state_changed", self, "_on_game_state_changed")
	_on_game_state_changed()

func _on_game_state_changed() -> void:
	for child in get_children():
		child.queue_free()
	
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
									 data[data_keys[col*cols+row]]['name'],
									 data_keys[col*cols+row])

func create_review_button(position : Vector2,\
						  size : Vector2,\
						  text : String,\
						  player_id: int) -> void:
	var instance = review_button.instance()
	add_child(instance)
	instance.set_position(position)
	instance.set_size(size)
	instance.player_id = player_id
	instance.text = text
