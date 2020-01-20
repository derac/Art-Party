extends Node

var player_label = preload("res://Components/Player_Label.tscn")

var player_array = []
var position = {"x" : 20,     "y" : 340,
				"width": 940, "height": 720}

var ip_list = {"asd": {"name": "dasdads"},
				"asd2": {"name": "dasdaads"},
				"asd3": {"name": "dasdadfds"},
				"asd4": {"name": "dasdfdads"},
				"asd5": {"name": "wfdssdfaaw"},
				"asd6": {"name": "fdgfdgsdfw"},
				"asd7": {"name": "wwwfgsdfw"},
				"asd8": {"name": "wwwgsdfgsww"},
				"asd9": {"name": "wwasdfsadsdgfdsf"},
				"asd10": {"name": "wwasdffsasdfasdf"},
				"asd11": {"name": "wadsfw"},
				"asd12": {"name": "wwwasdfasdfasd"},
				"asd13": {"name": "wwsdfasdfasdf"}}

func _ready():
	update_text()

func _on_Update_timeout():
	update_text()

func update_text():
	# Comment to use test data
	ip_list = UDP_Server.ip_list
	var ip_list_keys = ip_list.keys()
	var ip_list_size = ip_list_keys.size()
	var cols = floor(sqrt(ip_list_size))
	if cols > 0:
		var row_extra = floor((ip_list_size / cols) - cols)
		var last_row_extra = ip_list_size - cols * cols - row_extra * cols
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
				var player_instance = player_label.instance()
				player_array.append(player_instance)
				add_child(player_instance)
				player_instance.set_position(Vector2(position["x"] + col_x,
													 position["y"] + row_y))
				player_instance.set_size(Vector2(player_width,
												 player_height))
				player_instance.text = ip_list[ip_list_keys[col*cols+row]]["name"]
				if ip_list[ip_list_keys[col*cols+row]]["game_server"]:
					var style_box = preload("res://Styleboxes/Player_Label.tres")
					style_box.set_border_color(Color("#54a04f"))
					player_instance.text = "Join " + player_instance.text
					player_instance.set('custom_styles/normal', style_box)
