extends Node

var player_label := load("res://Screens/Components/Player_Label.tscn")
var server_label := load("res://Screens/Components/Join_Server.tscn")

var position := {"x" : 20,     "y" : 340,
				 "width": 1060, "height": 720}

func _ready():
	Global.connect("udp_data_changed", self, "_on_udp_data_changed")
	_on_udp_data_changed()

func _on_udp_data_changed():
	
	for child in get_children():
		child.queue_free()
	
	var data := Global.udp_data
	var data_keys := data.keys()
	var data_size := data_keys.size()
	var cols := floor(sqrt(data_size))
	
	if cols > 0:
		var row_extra := floor((data_size / cols) - cols)
		var player_width : int = (position["width"] - (20 * (cols - 1))) / cols
	
		for col in range(cols):
			var col_x := col * (player_width + 20)
			var rows := cols + row_extra
			if col == (cols - 1):
				rows += (data_size - cols * cols - row_extra * cols)
			for row in rows:
				var player_height = (position["height"] - 20 * (rows - 1)) / rows
				var row_y = row * (player_height + 20)
				# Creating and setting up a new player instance
				# Should probably refactor into own function
				var player_instance
				if data[data_keys[col*cols+row]]["is_server"]:
					player_instance = server_label.instance()
				else:
					player_instance = player_label.instance()
				add_child(player_instance)
				player_instance.set_position(Vector2(position["x"] + col_x,
													 position["y"] + row_y))
				player_instance.set_size(Vector2(player_width,
												 player_height))
				if data[data_keys[col*cols+row]]["is_server"]:
					player_instance.address = data[data_keys[col*cols+row]]
					player_instance.address["ip"] = data_keys[col*cols+row]
										
					var player_text = player_instance.get_node("Label")
					player_text.set_size(Vector2(player_width,
												 player_height))
					player_text.text = "Join " + data[data_keys[col*cols+row]]["name"]
				else:
					player_instance.text = data[data_keys[col*cols+row]]["name"]
