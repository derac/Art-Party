extends Button

var next_scene = preload("res://Lobby.tscn")

func _ready():
	pass
	
func _process(delta):
	pass

func _pressed():
	Global.game_server = true
	get_tree().change_scene_to(next_scene)
