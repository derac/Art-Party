extends Button

func _pressed():
	UDP_Server.udp.put_var("remove")
	get_tree().quit()
