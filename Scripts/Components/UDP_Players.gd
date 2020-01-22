extends Node

var player_label := preload("res://Screens/Components/Player_Label.tscn")
var server_label := preload("res://Screens/Components/Join_Server.tscn")

var player_array := []
export var position := {"x" : 20,     "y" : 340,
						"width": 1060, "height": 720}

func _ready():
	Global.connect("udp_data_changed", self, "_on_udp_data_changed")

func _on_udp_data_changed():
	var ip_list := Global.udp_data
#	var ip_list = {}
#	for i in range(10):
#		ip_list[str(i)] = {"name" : "sadasdas",
#						   "game_server" : 0,
#						   "last_tick": OS.get_system_time_msecs()}
	
	var ip_list_keys := ip_list.keys()
	var ip_list_size := ip_list_keys.size()
	var cols := floor(sqrt(ip_list_size))
	if cols > 0:
		var row_extra := floor((ip_list_size / cols) - cols)
		var last_row_extra := ip_list_size - cols * cols - row_extra * cols
		var player_width : int = (position["width"] - (20 * (cols - 1))) / cols
		
		for player in player_array:
			player.free()
		player_array = []
	
		for col in range(cols):
			var col_x := col * (player_width + 20)
			var rows := cols + row_extra
			if col == (cols - 1):
				rows += last_row_extra
			for row in rows:
				var player_height = (position["height"] - 20 * (rows - 1)) / rows
				var row_y = row * (player_height + 20)
				# Creating and setting up a new player instance
				# Should probably refactor into own function
				var player_instance
				if ip_list[ip_list_keys[col*cols+row]]["serving"]:
					player_instance = server_label.instance()
				else:
					player_instance = player_label.instance()
				player_array.append(player_instance)
				add_child(player_instance)
				player_instance.set_position(Vector2(position["x"] + col_x,
													 position["y"] + row_y))
				player_instance.set_size(Vector2(player_width,
												 player_height))
				if ip_list[ip_list_keys[col*cols+row]]["serving"]:
					player_instance.address = ip_list[ip_list_keys[col*cols+row]]
					player_instance.address["ip"] = ip_list_keys[col*cols+row]
										
					var player_text = player_instance.get_node("Label")
					player_text.set_size(Vector2(player_width,
												 player_height))
					player_text.text = ip_list[ip_list_keys[col*cols+row]]["name"]
				else:
					player_instance.text = ip_list[ip_list_keys[col*cols+row]]["name"]
