extends Control

var player_label = load("res://Screens/Components/Player_Label.tscn")
var server_label := load("res://Screens/Components/Join_Button.tscn")

func _ready():
	Global.connect("udp_data_changed", self, "_on_udp_data_changed")

func _on_udp_data_changed():
	for child in get_children():
		child.queue_free()
	
	var data = Global.udp_data
	var data_keys : Array = data.keys()
	var data_size : int = data_keys.size()
	var dimensions : Vector2
	var label_pos : Vector2
	
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
				
				create_player_label(label_pos,
									dimensions,
									data[data_keys[col*cols+row]],
									data_keys[col*cols+row])

func create_player_label(position : Vector2,\
						 size : Vector2,\
						 player_data : Dictionary,
						 player_ip : String) -> void:
	var instance
	name = player_data['name']
	if player_data['is_server']:
		instance = server_label.instance()
		name = "Join " + name
	else:
		instance = player_label.instance()
	add_child(instance)
	instance.set_position(position)
	instance.set_size(size)
	instance.text = name
	if player_data['is_server']:
		instance.address = {'ip': player_ip, 'port': player_data['port']}
