extends Button

onready var Game_Players := get_node("/root/Lobby/Information/Game_Players")
onready var Address = get_node("/root/Lobby/Information/Address")
onready var UPNP_Message = get_node("/root/Lobby/Information/UPNP")

func _ready() -> void:
	if Game_Server.is_server != true:
		set_visible(false)

func _pressed() -> void:
	if Global.external_ip == "":
		$HTTPRequest.request("http://ipinfo.io/ip")
	else:
		Address.set_address(Global.external_ip)
	UPNP_Message.set_visible(!UPNP_Message.is_visible())
	Address.set_visible(!Address.is_visible())
	if Address.is_visible():
		Sound.play_sfx("res://Assets/SFX/on.wav", -3, .5)
	else:
		Sound.play_sfx("res://Assets/SFX/on.wav", -3, .5)
		
	Game_Players.refresh()
	text = "copied"
	$Copy_Timer.start()

func _on_Copy_Timer_timeout() -> void:
	text = "my IP"

func _on_HTTPRequest_request_completed(_result: int, 
									   _response_code: int,
									   _headers: PoolStringArray,
									   body: PoolByteArray) -> void:
	Address.set_address(body.get_string_from_utf8())
