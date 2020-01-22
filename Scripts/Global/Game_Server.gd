extends Node

var serving := false
var server_port := (30000 + randi() % 30000)
var peer := NetworkedMultiplayerENet.new()
var player_info := {}

var start_screen := load("res://Screens/Start.tscn")

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _player_connected(id : int) -> void:
	player_info[id] = Global.my_name

func _player_disconnected(id : int) -> void:
	player_info.erase(id)

func _server_disconnected() -> void:
	stop_serving()
	UDP_Server.start_listening()
	get_tree().change_scene_to(start_screen)

func start_serving(retries : int) -> int:
	var err := peer.create_server(server_port, 32)
	if err == OK:
		get_tree().set_network_peer(peer)
		serving = true
	else:
		server_port = (30000 + randi() % 30000)
		start_serving(retries - 1)
	return err

func stop_serving() -> void:
	if serving == true:
		UDP_Server.udp.put_var("stop_serving")
		peer.close_connection()
		get_tree().set_network_peer(null)
		player_info = {}
		serving = false

func start_client(ip : String, port : int, retries : int) -> int:
	var err := peer.create_client(ip, port)
	if err == OK:
		get_tree().set_network_peer(peer)
	else:
		start_client(ip, port, retries - 1)
	return err

func stop_client() -> void:
	peer.close_connection()
	get_tree().set_network_peer(null)
