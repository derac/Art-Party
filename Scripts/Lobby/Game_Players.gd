extends Control

var ready_label = load("res://Screens/Components/Ready_Label.tscn")

func _ready():
	Global.connect("game_state_changed", self, "_on_game_state_changed")
	_on_game_state_changed()

func _on_game_state_changed():
	for child in get_children():
		child.queue_free()
	
	var data_keys : Array = Global.game_state.keys()
	var data_size : int = data_keys.size()
	var dimensions : Vector2
	var label_pos : Vector2
	
	var cols := floor(sqrt(data_size))
	if cols > 0:
		dimensions.x = (rect_size.x - (20 * (cols - 1))) / cols
		
		for col in range(cols):
			label_pos.x = col * (dimensions.x + 20) - 20
			var rows = cols + floor((data_size / cols) - cols)
			if col == (cols - 1):
				rows += (data_size - cols * rows)
				dimensions.y = (rect_size.y - 20 * (rows - 1)) / rows
			for row in rows:
				label_pos.y = row * (dimensions.y + 20) - 20
				
				create_ready_label(rect_position + label_pos,
									dimensions,
									Global.game_state[data_keys[col*cols+row]]['name'])

func create_ready_label(position : Vector2,\
						 size : Vector2,\
						 text : String) -> void:
	var instance = ready_label.instance()
	add_child(instance)
	instance.set_position(position)
	instance.set_size(size)
	instance.text = text
