extends Node

var is_client := false
var port := (30000 + randi() % 3001)
var peer := NetworkedMultiplayerENet.new()

var setup_screen := load("res://Screens/Setup.tscn")
var play_screen := load("res://Screens/Play.tscn")

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	peer.connect("connection_succeeded", self, "_connection_succeeded")

func _player_connected(id : int) -> void:
	rpc_id(id, "register_player", new_data())

func _player_disconnected(id : int) -> void:
	Global.game_state.erase(id)
	# Trigger setter
	Global.game_state_set(Global.game_state)

func _server_disconnected() -> void:
	get_tree().change_scene_to(setup_screen)

func _connection_succeeded() -> void:
	Global.game_state[peer.get_unique_id()] = new_data()
	is_client = true
	
remote func register_player(player_data : Dictionary) -> void:
	var id = get_tree().get_rpc_sender_id()
	Global.game_state[id] = player_data

remotesync func start_game() -> void:
	get_tree().change_scene_to(play_screen)

remotesync func send_data(data, id) -> void:
	Global.game_state[id]["cards"].append(data)
	# Trigger signal
	Global.game_state_set(Global.game_state)

func start_serving(retries : int = 3) -> int:
	var err : int
	if !get_tree().is_network_server():
		err = peer.create_server(port, 32)
		if err == OK:
			Global.game_state[1] = new_data()
			get_tree().set_network_peer(peer)
			return err
		elif retries > 0:
			port = (30000 + randi() % 3001)
			start_serving(retries - 1)
	return err

func stop_serving() -> void:
	if get_tree().is_network_server():
		UDP_Broadcast.udp.put_var("stop_serving")
		peer.close_connection()
		Global.game_state = {}

func start_client(ip : String, port : int):
	if is_client == false:
		get_tree().set_network_peer(null)
		var err := peer.create_client(ip, port)
		if err == OK:
			get_tree().set_network_peer(peer)

func stop_client() -> void:
	if is_client == true:
		peer.close_connection()
		Global.game_state = {}
		is_client = false

func new_data() -> Dictionary:
	return {'name': Global.my_name, 'cards': []}
