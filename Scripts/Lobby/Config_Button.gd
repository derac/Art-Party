extends Button

func _ready():
	$HTTPRequest.request("http://ipinfo.io/ip")

func _pressed():
	$Address.set_visible(!$Address.is_visible())
	OS.set_clipboard($Address.text)
	text = "copied"
	$Copy_Timer.start()

func _on_Copy_Timer_timeout():
	text = "IP"

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$Address.text = "%s:%s" % [body.get_string_from_utf8(), Game_Server.server_port]
