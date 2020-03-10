extends Button

func set_address(address) -> void:
	Global.external_ip = address
	text = "%s:%s" % [address, Game_Server.port]
	OS.set_clipboard(text)

func _pressed() -> void:
	print("pressed")
	text = "copied"
	$Copy_Timer.start()

func _on_Copy_Timer_timeout():
	set_address(Global.external_ip)
