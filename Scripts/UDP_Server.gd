extends Node

var udp = PacketPeerUDP.new()
const PORT = 23572
var heartbeat_timer = OS.get_system_time_msecs()
var ip_list = {}

func _ready():
	# Broadcasting setup
	udp.set_broadcast_enabled(true) # Needed for broadcasting on Android
	udp.set_dest_address("255.255.255.255", PORT)
	udp.listen(PORT)

func _process(_delta):
	if udp.is_listening():
		process_udp()
		send_heartbeat()

func process_udp():
	if udp.get_available_packet_count() > 0:
		var data_dict = udp.get_var()
		var inc_ip = udp.get_packet_ip()
		if data_dict is String and data_dict == "remove":
			ip_list.erase(inc_ip)
			return
		if !(data_dict is Dictionary)\
		   or !data_dict.has("name")\
		   or !data_dict.has("game_server"):
			return
		data_dict["last_tick"] = OS.get_system_time_msecs()
		ip_list[inc_ip] = data_dict

func send_heartbeat():
	if OS.get_system_time_msecs() - heartbeat_timer > 500:
		heartbeat_timer = OS.get_system_time_msecs()
		udp.put_var({"name": Global.my_name,
					 "game_server": Global.game_server})
		# Remove inactive players
		for ip in ip_list.keys():
			if heartbeat_timer - ip_list[ip]["last_tick"] > 5000:
				ip_list.erase(ip)
