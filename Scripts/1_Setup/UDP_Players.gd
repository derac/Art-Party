extends Stretch_Grid

var player_label := load("res://Screens/Components/Player_Label.tscn")
var server_label := load("res://Screens/Components/Join_Button.tscn")

func _ready() -> void:
	Global.connect("udp_data_changed", self, "_on_udp_data_changed")
	
func _on_udp_data_changed() -> void:
	for child in get_children():
		child.queue_free()

	for player in Global.udp_data.keys():
		create_player_label(Global.udp_data[player], player)
		

func create_player_label(player_data : Dictionary,
						 player_ip : String) -> void:
	var instance
	var player_name = player_data['name']
	if !player_name:
		player_name = "anonymous"
	if player_data['is_server']:
		instance = server_label.instance()
		player_name = "join " + player_name
	else:
		instance = player_label.instance()
	add_child(instance)
	instance.text = player_name
	if player_data['is_server']:
		instance.address = {'ip': player_ip, 'port': player_data['port']}
