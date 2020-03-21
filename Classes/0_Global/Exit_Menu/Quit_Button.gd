extends Button

func _pressed() -> void:
	Broadcast.request_removal()
	get_tree().quit()
