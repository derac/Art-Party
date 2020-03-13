extends Node

var error : int
var peer := NetworkedMultiplayerENet.new()
var is_client := false
var server_address := {}
var is_server := false
var disconnected_players := []
var port := (30000 + randi() % 3001)

var setup_screen := load("res://Screens/Setup.tscn")
var play_screen := load("res://Screens/Play.tscn")

func _ready() -> void:
	Log.if_error(get_tree().connect("network_peer_connected", self, "_player_connected"),
				 'Failed: get_tree().connect("network_peer_connected", self, "_player_connected")')
	Log.if_error(get_tree().connect("network_peer_disconnected", self, "_player_disconnected"),
				 'Failed: get_tree().connect("network_peer_disconnected", self, "_player_disconnected")')
	Log.if_error(get_tree().connect("server_disconnected", self, "_server_disconnected"),
				 'Failed: get_tree().connect("server_disconnected", self, "_server_disconnected")')
	Log.if_error(peer.connect("connection_succeeded", self, "_connection_succeeded"),
				 'Failed: peer.connect("connection_succeeded", self, "_connection_succeeded")')

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT and OS.get_name() in ["Android", "Blackberry 10", "iOS"]:
		if get_tree().get_current_scene().get_name() == "Lobby":
			go_to_setup()
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		if is_client:
			peer.close_connection()
			Log.if_error(Game_Server.start_client(server_address["ip"], int(server_address["port"])),
						 "Could not start game client at %s:%s." % [server_address["ip"], server_address["port"]])

func _player_connected(net_id : int) -> void:
	if OS.get_unique_id() in Global.game_state:
		rpc_id(net_id, "register_player", Global.game_state[OS.get_unique_id()], OS.get_unique_id())
	else:
		rpc_id(net_id, "register_player", new_data(), OS.get_unique_id())

func _player_disconnected(net_id : int) -> void:
	match get_tree().get_current_scene().get_name():
		"Lobby":
			if not Global.game_state.erase(net_id_to_uuid(net_id)):
				print("Tried to remove %s from Global.game_state, but it doesn't exist." % net_id)
			else:
				# Trigger setter
				Global.game_state_set(Global.game_state)
		"Play":
			if is_server:
				peer.set_refuse_new_connections(false)
				#UDP_Broadcast.broadcasting = true
				disconnected_players.append(net_id_to_uuid(net_id))
				print("disconnected_players: %s" % String(disconnected_players))

func _server_disconnected() -> void:
	if get_tree().get_current_scene().get_name() != "End":
		print("server disconnected.")
		go_to_setup()

func _connection_succeeded() -> void:
	rpc_id(1, "get_local_data", OS.get_unique_id())
	is_client = true

remote func get_local_data(uuid: String) -> void:
	print("player connected: %s" % uuid)
	var net_id = get_tree().get_rpc_sender_id()
	if disconnected_players.size():
		if uuid in disconnected_players:
			disconnected_players.erase(uuid)
		else:
			rpc_id(net_id, "kick")
			return
		if not disconnected_players.size():
			peer.set_refuse_new_connections(true)
			#UDP_Broadcast.broadcasting = false
	if uuid in Global.game_state:
		Global.game_state[uuid]["net_id"] = net_id
		rpc_id(net_id, "set_local_data", Global.game_state[uuid])
	else:
		rpc_id(net_id, "set_local_data", null)

remote func set_local_data(data : Dictionary) -> void:
	if data:
		Global.game_state[OS.get_unique_id()] = data
	else:
		Global.game_state[OS.get_unique_id()] = new_data()

remote func register_player(player_data : Dictionary,
							player_id : String) -> void:
	Global.game_state[player_id] = player_data

remotesync func send_data(card_data, stack_id : String, sender_id : String) -> void:
	Global.game_state[stack_id]["cards"].append(card_data)
	Global.game_state[stack_id]["played_by"].append(sender_id)
	# Trigger signal
	Global.game_state_set(Global.game_state)

remote func kick() -> void:
	go_to_setup()

func start_serving(retries : int = 3) -> int:
	error = 1
	if !is_server:
		error = Log.if_error(peer.create_server(port, 64),
							 "Failed to start server at UDP port %s." % String(port))
		if not error:
			is_server = true
			Global.game_state[OS.get_unique_id()] = new_data()
			get_tree().set_network_peer(peer)
			return error
		elif retries > 0:
			port = (30000 + randi() % 3001)
			return start_serving(retries - 1)
	return error

func stop_serving() -> void:
	UDP_Broadcast.stop_serving()
	if peer.get_connection_status() != 0:
		peer.close_connection()
	is_server = false
	Global.game_state = {}

func start_client(ip : String, server_port : int) -> int:
	get_tree().set_network_peer(null)
	error = peer.create_client(ip, server_port)
	if not error:
		get_tree().set_network_peer(peer)
		is_client = true
	return error

func stop_client() -> void:
	if peer.get_connection_status() != 0:
		peer.close_connection()
	is_client = false
	Global.game_state = {}

func go_to_setup():
	Log.if_error(get_tree().change_scene_to(setup_screen),
				 "Failed to change scene to setup_screen")
		
func net_id_to_uuid(net_id : int) -> String:
	for uuid in Global.game_state:
		if net_id == Global.game_state[uuid]["net_id"]:
			return uuid
	return ""

func new_data() -> Dictionary:
	var net_id : int
	if is_server:
		net_id = 1
	else:
		net_id = get_tree().get_network_unique_id()
	return {'name': Global.my_name, 'net_id': net_id, 'cards': [], 'played_by': []}
