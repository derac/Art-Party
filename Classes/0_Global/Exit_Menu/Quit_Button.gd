extends Button

func _pressed() -> void:
	UDP_Broadcast.request_removal()
	get_tree().quit()
