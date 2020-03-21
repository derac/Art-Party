extends Node

var udp := PacketPeerUDP.new()
const PORT = 23572
var heartbeat_timer := OS.get_system_time_msecs()
var player_ticks := {}
var listening := false
var broadcasting := false setget set_broadcasting
signal broadcasting_changed

func _ready() -> void:
	udp.set_broadcast_enabled(true)
	start_listening()
	set_broadcasting(true)

func _process(_delta) -> void:
	if listening and udp.get_available_packet_count() > 0:
		var data = udp.get_var()
		var ip = udp.get_packet_ip()
		run_command(ip, data)
		update_udp_data(ip, data)
	if broadcasting:
		send_heartbeat()

func run_command(ip, data) -> void:
	if data is String and Global.udp_data.has(ip):
		if data == "remove":
			remove_player(ip)
		if data == "stop_serving":
			Global.udp_data[ip]["is_server"] = false

func update_udp_data(ip, data) -> void:
	if (data is Dictionary) and data.has_all(["name", "is_server", "port"]):
		player_ticks[ip] = OS.get_system_time_msecs()
		if not Global.udp_data.has(ip) or Global.udp_data[ip].hash() != data.hash():
			Global.udp_data[ip] = data

func send_heartbeat() -> void:
	if OS.get_system_time_msecs() - heartbeat_timer > 250:
		heartbeat_timer = OS.get_system_time_msecs()
		set_broadcasting(
			not Log.if_error(udp.put_var({"name": Global.my_name,
										  "is_server": Game_Server.is_server,
										  "port": Game_Server.port}),
							 "Failed to send current broadcast data."))
		remove_inactive()

func remove_inactive() -> void:
	if listening:
		for ip in Global.udp_data.keys():
			if heartbeat_timer - player_ticks[ip] > 1000:
				remove_player(ip)

func remove_player(ip : String) -> void:
	if Global.udp_data.erase(ip):
		# Trigger setter for signaling
		Global.udp_data_set(Global.udp_data)
	else:
		Log.write("Tried to remove %s from udp_data, but it doesn't exist." % ip)

func request_removal() -> void:
	Log.if_error(udp.put_var("remove"),
				 "Failed to broadcast remove command.")
				
	
func set_broadcasting(value : bool):
	if broadcasting != value:
		if value:
			broadcasting = not Log.if_error(udp.set_dest_address("255.255.255.255", PORT),
											"Failed to broadcast on UDP 255.255.255.255:%s" % String(PORT))
		else:
			broadcasting = false
			request_removal()
		if broadcasting == value:
			emit_signal("broadcasting_changed")
			
func start_listening():
	if udp.is_listening():
		listening = true
	else:
		listening = not Log.if_error(udp.listen(PORT),
									 "Failed to listen on UDP port %s." % String(PORT))

func stop_serving() -> void:
	Log.if_error(udp.put_var("stop_serving"),
				 "Failed to broadcast stop_serving command.")

func _exit_tree() -> void:
	udp.close()
