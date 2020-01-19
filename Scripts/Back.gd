extends Button

var next_scene = load("res://Info.tscn")

func _ready():
	pass
	
func _process(delta):
	pass

func _pressed():
	get_tree().change_scene_to(next_scene)
