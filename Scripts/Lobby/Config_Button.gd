extends Button

var upnp = UPNP.new()

func _ready():
	$HTTPRequest.request("http://ipinfo.io/ip")

func _pressed():
	var result = upnp.discover()
	var gateway
	
	if result == 0:
		gateway = upnp.get_gateway()
		if gateway.is_valid_gateway():
			var err = gateway.add_port_mapping(Game_Server.port)
			if err == 0:
				$Address/Label.set_visible(false)
	
	$Address.set_visible(!$Address.is_visible())
	OS.set_clipboard($Address.text)
	text = "copied"
	$Copy_Timer.start()

func _on_Copy_Timer_timeout():
	text = "my IP"

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$Address.text = "%s:%s" % [body.get_string_from_utf8(), Game_Server.port]
