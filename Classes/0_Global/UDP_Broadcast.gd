extends Node

var udp := PacketPeerUDP.new()
const PORT = 23572
var heartbeat_timer := OS.get_system_time_msecs()
var player_ticks := {}
var listening := true
var broadcasting := true
var err

func _ready() -> void:
	udp.set_broadcast_enabled(true) # Needed for broadcasting on Android
	err = udp.set_dest_address("255.255.255.255", PORT)
	if err:
		print("Failed to broadcast on UDP 255.255.255.255:" + String(PORT))
	err = udp.listen(PORT)
	if err:
		print("Failed to listen on UDP port " + String(PORT))

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
			if not Global.udp_data.erase(ip):
				print("Tried to remove %s from udp_data, but it doesn't exist." % ip)
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
			err = udp.put_var({"name": Global.my_name,
							   "is_server": Game_Server.is_server,
							   "port": Game_Server.port})
			if err:
				print("Failed to send current broadcast data.")
			remove_inactive()

func remove_inactive() -> void:
	if listening:
		for ip in Global.udp_data.keys():
			if heartbeat_timer - player_ticks[ip] > 1000:
				if not Global.udp_data.erase(ip):
					print("Tried to remove %s from udp_data, but it doesn't exist." % ip)
				# Trigger setter for signaling
				else:
					Global.udp_data_set(Global.udp_data)

func _exit_tree() -> void:
	udp.close()
