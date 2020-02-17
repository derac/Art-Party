extends Sprite

func _ready() -> void:
	Global.connect("color_changed", self, "_on_color_changed")

func _on_color_changed() -> void:
	self_modulate = Global.color
