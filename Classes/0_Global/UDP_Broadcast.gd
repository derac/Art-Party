extends Node

var udp := PacketPeerUDP.new()
const PORT = 23572
var heartbeat_timer := OS.get_system_time_msecs()
var player_ticks := {}
var listening := true
var broadcasting := true

func _ready() -> void:
	# Broadcasting setup
	udp.set_broadcast_enabled(true) # Needed for broadcasting on Android
	udp.set_dest_address("255.255.255.255", PORT)
	udp.listen(PORT)

func _process(_delta) -> void:
	if listening and udp.get_available_packet_count() > 0:
		var data = udp.get_var()
		var ip = udp.get_packet_ip()
		run_command(ip, data)
		update_udp_data(ip, data)
		
	send_heartbeat()

func run_command(ip, data) -> void:
	if data is String and Global.udp_data.has(ip):
		if data == "remove":
			Global.udp_data.erase(ip)
			# Trigger setter for signaling
			Global.udp_data_set(Global.udp_data)
		if data == "stop_serving":
			Global.udp_data[ip]["is_server"] = false

func update_udp_data(ip, data) -> void:
	if (data is Dictionary) and data.has_all(["name", "is_server", "port"]):
		player_ticks[ip] = OS.get_system_time_msecs()
		if not Global.udp_data.has(ip) or Global.udp_data[ip].hash() != data.hash():
			Global.udp_data[ip] = data

func send_heartbeat() -> void:
	if broadcasting:
		if OS.get_system_time_msecs() - heartbeat_timer > 100:
			heartbeat_timer = OS.get_system_time_msecs()
			udp.put_var({"name": Global.my_name,
						 "is_server": Game_Server.is_server,
						 "port": Game_Server.port})
			remove_inactive()

func remove_inactive() -> void:
	if listening:
		for ip in Global.udp_data.keys():
			if heartbeat_timer - player_ticks[ip] > 1000:
				Global.udp_data.erase(ip)
				# Trigger setter for signaling
				Global.udp_data_set(Global.udp_data)

func _exit_tree() -> void:
	udp.close()
