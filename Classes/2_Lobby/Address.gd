extends LineEdit

func set_address(address) -> void:
	Global.external_ip = address
	text = "%s:%s" % [address, Game_Server.port]
	OS.set_clipboard(text)
