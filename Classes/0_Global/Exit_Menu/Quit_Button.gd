extends Button

func _pressed() -> void:
	UDP_Broadcast.remove_self()
	get_tree().quit()
