extends Button


func _pressed() -> void:
	Sound.play_sfx("res://Assets/SFX/good.wav", 0.0, 2.0)
	OS.set_clipboard("https://derac.itch.io/artparty")
	text = "copied"
	yield(get_tree().create_timer(.5), "timeout")
	text = "share"
