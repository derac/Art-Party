extends Node

var udp = PacketPeerUDP.new()
const PORT = 23572

func _ready():
	# Window setup
	OS.set_borderless_window(true)
	OS.set_window_maximized(true)
	OS.set_window_size(OS.get_screen_size())
	OS.set_window_position(Vector2(0, 0))
	# Broadcasting setup
	udp.set_broadcast_enabled(true) # Needed for broadcasting on Android
	udp.set_dest_address("255.255.255.255", PORT)
	udp.listen(PORT)

# Esc (default cancel key) to exit
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(_delta):
	if udp.is_listening() and udp.get_available_packet_count() > 0:
		var pkt = udp.get_var()
		var inc_ip = udp.get_packet_ip()
		$Messages.text += inc_ip + ": " + pkt + "\n"

func _on_Send_button_down():
	udp.put_var($Input.text)
	$Input.text = ""
