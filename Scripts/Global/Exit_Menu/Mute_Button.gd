extends CheckBox

func _ready():
	pass

func _toggled(button_pressed: bool) -> void:
	Sound.set_mute(button_pressed)
