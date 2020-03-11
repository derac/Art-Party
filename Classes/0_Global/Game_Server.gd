extends Node

var error : int
var disconnected_players := []

var is_client := false
var is_server := false
var port := (30000 + randi() % 3001)
var peer := NetworkedMultiplayerENet.new()

var setup_screen := load("res://Screens/Setup.tscn")

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	peer.connect("connection_succeeded", self, "_connection_succeeded")

func _player_connected(net_id : int) -> void:
	rpc_id(net_id, "register_player", new_data(), OS.get_unique_id())

func _player_disconnected(net_id : int) -> void:
	match get_tree().get_current_scene().get_name():
		"Lobby":
			for uuid in Global.game_state.keys():
				if Global.game_state[uuid]["peer_id"] == net_id:
					if not Global.game_state.erase(uuid):
						print("Tried to remove %s from Global.game_state, but it doesn't exist." % uuid)
					else:
						# Trigger setter
						Global.game_state_set(Global.game_state)
					break
		"Play":
			for uuid in Global.game_state.keys():
				if Global.game_state[uuid]["peer_id"] == net_id:
					disconnected_players.append(uuid)
			print("disconnected_players: %s" % String(disconnected_players))

func _server_disconnected() -> void:
	if get_tree().get_current_scene().get_name() != "End":
		print("server disconnected.")
		error = get_tree().change_scene_to(setup_screen)
		if error:
			print("Failed to change scene to setup_screen")

func _connection_succeeded() -> void:
	Global.game_state[OS.get_unique_id()] = new_data()
	is_client = true
	
remote func register_player(player_data : Dictionary,
							player_id : String) -> void:
	Global.game_state[player_id] = player_data

remotesync func send_data(card_data, stack_id : String, sender_id : String) -> void:
	Global.game_state[stack_id]["cards"].append(card_data)
	Global.game_state[stack_id]["played_by"].append(sender_id)
	# Trigger signal
	Global.game_state_set(Global.game_state)

func start_serving(retries : int = 3) -> int:
	error = 1
	if !is_server:
		error = peer.create_server(port, 64)
		if not error:
			Global.game_state[OS.get_unique_id()] = new_data()
			get_tree().set_network_peer(peer)
			is_server = true
			return error
		elif retries > 0:
			print("Failed to start server at UDP port %s." % String(port))
			port = (30000 + randi() % 3001)
			return start_serving(retries - 1)
	return error

func stop_serving() -> void:
	if is_server:
		UDP_Broadcast.stop_serving()
		peer.close_connection()
		is_server = false
		Global.game_state = {}

func start_client(ip : String, server_port : int):
	if is_client == false:
		get_tree().set_network_peer(null)
		error = peer.create_client(ip, server_port)
		if not error:
			get_tree().set_network_peer(peer)
			is_client = true
		else:
			print("Could not start game client at %s:%s." % [ip, String(server_port)])

func stop_client() -> void:
	if is_client == true:
		peer.close_connection()
		is_client = false
		Global.game_state = {}

func new_data() -> Dictionary:
	return {'name': Global.my_name, 'peer_id': peer.get_unique_id(), 'cards': [], 'played_by': []}
