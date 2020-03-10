extends Button

func _pressed():
	get_parent().initialize_UPNP()
