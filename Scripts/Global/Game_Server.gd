extends Node

var is_server := false
var is_client := false
var server_port := (30000 + randi() % 30000)
var peer := NetworkedMultiplayerENet.new()

var start_screen := load("res://Screens/Start.tscn")

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _process(_delta) -> void:
	print(Game_Server.peer.get_connection_status())
	
func _player_connected(id : int) -> void:
	rpc_id(id, "register_player", Global.my_name)

func _player_disconnected(id : int) -> void:
	Global.game_data.erase(id)
	# Crappy workaround to trigger setter
	Global.game_data_set(Global.game_data)

func _server_disconnected() -> void:
	get_tree().change_scene_to(start_screen)
	
remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	Global.game_data[id] = info

func start_serving(retries : int) -> int:
	var err : int
	if is_server == false:
		err = peer.create_server(server_port, 32)
		if err == OK:
			Global.game_data[1] = Global.my_name
			get_tree().set_network_peer(peer)
			is_server = true
			return err
		else:
			server_port = (30000 + randi() % 30000)
			start_serving(retries - 1)
	return err

func stop_serving() -> void:
	if is_server == true:
		UDP_Server.udp.put_var("stop_serving")
		peer.close_connection()
		Global.game_data = {}
		is_server = false

func start_client(ip : String, port : int, retries : int) -> int:
	if is_client == false:
		get_tree().set_network_peer(null)
		var err := peer.create_client(ip, port)
		if err == OK:
			get_tree().set_network_peer(peer)
			Global.game_data[peer.get_unique_id()] = Global.my_name
			is_client = true
		else:
			start_client(ip, port, retries - 1)
		return err
	return OK

func stop_client() -> void:
	if is_client == true:
		peer.close_connection()
		Global.game_data = {}
		is_client = false
