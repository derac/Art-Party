extends Sprite

func _ready():
	Global.connect("color_changed", self, "_on_color_changed")

func _on_color_changed():
	self_modulate = Global.color
