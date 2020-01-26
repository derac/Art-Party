extends Control

var player_label = load("res://Screens/Components/Player_Label.tscn")
var start_screen := load("res://Screens/Start.tscn")

func _ready():
	Global.connect("game_data_changed", self, "_on_game_data_changed")
	_on_game_data_changed()

func _on_game_data_changed():
	for child in get_children():
		child.queue_free()
	
	var data_keys : Array = Global.game_data.keys()
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
			for row in rows:
				dimensions.y = (rect_size.y - 20 * (rows - 1)) / rows
				label_pos.y = row * (dimensions.y + 20) - 20
				
				create_player_label(rect_position + label_pos,
									dimensions,
									Global.game_data[data_keys[col*cols+row]])

func create_player_label(position : Vector2,\
						 size : Vector2,\
						 text : String) -> void:
	var instance = player_label.instance()
	add_child(instance)
	instance.set_position(position)
	instance.set_size(size)
	instance.text = text
