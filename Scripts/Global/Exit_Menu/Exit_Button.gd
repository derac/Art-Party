extends Button

func _pressed():
	UDP_Broadcast.udp.put_var("remove")
	get_tree().quit()
