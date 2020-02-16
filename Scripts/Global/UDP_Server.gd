extends Node

var udp := PacketPeerUDP.new()
const PORT = 23572
var heartbeat_timer := OS.get_system_time_msecs()
var listening := true
var broadcasting := true

func _ready():
	# Broadcasting setup
	udp.set_broadcast_enabled(true) # Needed for broadcasting on Android
	udp.set_dest_address("255.255.255.255", PORT)
	udp.listen(PORT)

func _process(_delta):
	process_udp()
	send_heartbeat()

func process_udp():
	if listening and udp.get_available_packet_count() > 0:
		var inc_var = udp.get_var()
		var inc_ip = udp.get_packet_ip()
		if inc_var is String and Global.udp_data.has(inc_ip):
			if inc_var == "remove":
				Global.udp_data.erase(inc_ip)
				# Crappy workaround to trigger setter signal
				Global.udp_data_set(Global.udp_data)
			if inc_var == "stop_serving":
				Global.udp_data[inc_ip]["is_server"] = false
		if (inc_var is Dictionary) and inc_var.has_all(["name", "is_server", "port"]):
			inc_var["last_tick"] = OS.get_system_time_msecs()
			Global.udp_data[inc_ip] = inc_var
			if !Global.my_ip and inc_ip in IP.get_local_addresses():
				Global.my_ip = inc_ip

func send_heartbeat():
	if broadcasting:
		if OS.get_system_time_msecs() - heartbeat_timer > 500:
			heartbeat_timer = OS.get_system_time_msecs()
			udp.put_var({"name": Global.my_name,
						 "is_server": get_tree().is_network_server(),
						 "port": Game_Server.server_port})
			# Remove inactive players
			if listening:
				for ip in Global.udp_data.keys():
					if heartbeat_timer - Global.udp_data[ip]["last_tick"] > 5000:
						Global.udp_data.erase(ip)
						# Crappy workaround to trigger setter
						Global.udp_data_set(Global.udp_data)
	
func _exit_tree():
	udp.close()
