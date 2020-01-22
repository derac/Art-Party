extends Button

var start_screen := load("res://Screens/Start.tscn")

func _ready() -> void:
	pass

func _process(_delta) -> void:
	pass

func _pressed() -> void:
	Game_Server.stop_serving()
	UDP_Server.start_listening()
	get_tree().change_scene_to(start_screen)
