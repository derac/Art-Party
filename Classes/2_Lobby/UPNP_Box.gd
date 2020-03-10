extends HBoxContainer

var upnp := UPNP.new()

const UPNP_Message_stylebox = preload("res://Screens/Styles/UPNP_Message.tres")
onready var Address = get_node("/root/Lobby/Information/Address")

func _enter_tree():
	set_UPNP_Message()

func initialize_UPNP() -> void:
	if upnp.discover() == UPNP.UPNP_RESULT_SUCCESS:
		var gateway = upnp.get_gateway()
		if gateway.is_valid_gateway() and gateway.add_port_mapping(Game_Server.port) == 0:
			Address.set_address(gateway.query_external_address())
			Global.UPNP_state = "success"
			Sound.play_sfx("res://Assets/SFX/good.wav", -5)
	if not Global.UPNP_state == "success":
		Global.UPNP_state = "failed"
		Sound.play_sfx("res://Assets/SFX/bad.wav", -10, .75)
	set_UPNP_Message()

func set_UPNP_Message() -> void:
	if Global.UPNP_state != "uninitialized":
		$UPNP_Button.set_visible(false)
	if Global.UPNP_state == "success":
		UPNP_Message_stylebox.set_border_color(Color("#008751"))
		$UPNP_Message.text = "Port forwarded with UPNP. If connection does not work, forward UDP ports 30000-33000."
	if Global.UPNP_state == "failed":
		UPNP_Message_stylebox.set_border_color(Color("#FF004D"))
		$UPNP_Message.text = "Could not forward server port with UPNP. Please forward UDP ports 30000-33000."


