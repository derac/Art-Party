extends Button

onready var color_picker = get_node('/root/Play/Controls/Color_Picker')
onready var color = Color(name)

func _ready() -> void:
	self_modulate = color

func _pressed() -> void:
	Sound.play_sfx("res://Assets/SFX/on.wav")
	color_picker.color = color
	get_parent().set_visible(false)
