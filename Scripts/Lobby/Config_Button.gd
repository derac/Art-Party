extends Button

func _ready():
	for interface in IP.get_local_interfaces():
		if Global.my_ip in interface["addresses"]:
			for address in interface["addresses"]:
				if address.find(":") > 0:
					$Address.text = "[%s]:%s" % [address, Game_Server.server_port]
					return

func _pressed():
	$Address.set_visible(!$Address.is_visible())
	OS.set_clipboard($Address.text)
	text = "copied"
	$Copy_Timer.start()


func _on_Copy_Timer_timeout():
	text = "IP"
