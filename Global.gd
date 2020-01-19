extends Node

var Name_Generator = preload("res://Scripts/name-generator.gd")

var udp = PacketPeerUDP.new()
const PORT = 23572
var heartbeat_timer = OS.get_ticks_msec()
var ip_list = {}
var my_name = ""

func _ready():
	randomize()
	# Window setup
	OS.set_borderless_window(true)
	OS.set_window_maximized(true)
	OS.set_window_size(OS.get_screen_size())
	OS.set_window_position(Vector2(0, 0))
	# Broadcasting setup
	udp.set_broadcast_enabled(true) # Needed for broadcasting on Android
	udp.set_dest_address("255.255.255.255", PORT)
	udp.listen(PORT)
	# Set name
	my_name = Name_Generator.generate(7,10)

# Esc (default cancel key) to exit
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(_delta):
	# Process incoming udp packets
	if udp.is_listening() and udp.get_available_packet_count() > 0:
		var inc_name = udp.get_var()
		var inc_ip = udp.get_packet_ip()
		if !ip_list.keys().has(inc_ip):
			ip_list[inc_ip] = {"last_tick" : OS.get_ticks_msec(),
							   "name" : inc_name}
		else:
			if ip_list[inc_ip]["name"] != inc_name:
				ip_list[inc_ip]["name"] = inc_name
			ip_list[inc_ip]["last_tick"] = OS.get_ticks_msec()
	# Send heartbeat
	if OS.get_ticks_msec() - heartbeat_timer > 500:
		heartbeat_timer = OS.get_ticks_msec()
		udp.put_var(my_name)
		# Remove inactive players
		for ip in ip_list.keys():
			if OS.get_ticks_msec() - ip_list[ip]["last_tick"] > 5000:
				ip_list.erase(ip)

func start_server():
	pass
