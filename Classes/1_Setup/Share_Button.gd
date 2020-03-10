extends Button


func _pressed() -> void:
	OS.set_clipboard("https://derac.itch.io/artparty")
	text = "copied"
	$Copy_Timer.start()
	
func _on_Copy_Timer_timeout():
	text = "share"
