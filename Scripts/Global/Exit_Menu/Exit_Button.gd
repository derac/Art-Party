extends Button

func _pressed() -> void:
	UDP_Broadcast.udp.put_var("remove")
	get_tree().quit()
