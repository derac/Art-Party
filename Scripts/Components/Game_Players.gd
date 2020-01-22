extends Node

var player_label = preload("res://Screens/Components/Player_Label.tscn")
var server_label = preload("res://Screens/Components/Join_Server.tscn")

var player_array = []
export var position = {"x" : 20,     "y" : 340,
				"width": 1060, "height": 720}

func _ready():
	update_text()

func _on_Update_timeout():
	update_text()

func update_text():
	# Comment to use test inc_var
	#var udp_data = UDP_Server.udp_data
	var udp_data = {}
	for i in range(10):
		udp_data[str(i)] = {"name" : "sadasdas",
						   "serving" : 0,
						   "port": 12354,
						   "last_tick": OS.get_system_time_msecs()}
	
	var udp_data_keys = udp_data.keys()
	var udp_data_size = udp_data_keys.size()
	var cols = floor(sqrt(udp_data_size))
	if cols > 0:
		var row_extra = floor((udp_data_size / cols) - cols)
		var last_row_extra = udp_data_size - cols * cols - row_extra * cols
		var player_width = (position["width"] - (20 * (cols - 1))) / cols
		
		for player in player_array:
			player.free()
		player_array = []
	
		for col in range(cols):
			var col_x = col * (player_width + 20)
			var rows = cols + row_extra
			if col == (cols - 1):
				rows += last_row_extra
			for row in rows:
				var player_height = (position["height"] - 20 * (rows - 1)) / rows
				var row_y = row * (player_height + 20)
				# Creating and setting up a new player instance
				# Should probably refactor into own function
				var player_instance
				if udp_data[udp_data_keys[col*cols+row]]["serving"]:
					player_instance = server_label.instance()
				else:
					player_instance = player_label.instance()
				player_array.append(player_instance)
				add_child(player_instance)
				player_instance.set_position(Vector2(position["x"] + col_x,
													 position["y"] + row_y))
				player_instance.set_size(Vector2(player_width,
												 player_height))
				player_instance.text = udp_data[udp_data_keys[col*cols+row]]["name"]
				
