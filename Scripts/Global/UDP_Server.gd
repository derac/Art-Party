extends Node

var udp := PacketPeerUDP.new()
const PORT = 23572
var heartbeat_timer := OS.get_system_time_msecs()
var ip_list := {}
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
		if inc_var is String and ip_list.has(inc_ip):
			if inc_var == "remove":
				ip_list.erase(inc_ip)
			if inc_var == "stop_serving":
				ip_list[inc_ip]["serving"] = false
		if (inc_var is Dictionary) and inc_var.has("name")\
		and inc_var.has("serving") and inc_var.has("port"):
			inc_var["last_tick"] = OS.get_system_time_msecs()
			ip_list[inc_ip] = inc_var

func send_heartbeat():
	if broadcasting:
		if OS.get_system_time_msecs() - heartbeat_timer > 500:
			heartbeat_timer = OS.get_system_time_msecs()
			udp.put_var({"name": Global.my_name,
						 "serving": Game_Server.serving,
						 "port": Game_Server.server_port})
			# Remove inactive players
			if listening:
				for ip in ip_list.keys():
					if heartbeat_timer - ip_list[ip]["last_tick"] > 5000:
						ip_list.erase(ip)

func stop_listening():
	listening = false
	ip_list = {}

func start_listening():
	listening = true

func start_broadcasting():
	broadcasting = true

func stop_broadcasting():
	broadcasting = false
	
func _exit_tree():
	udp.close()
