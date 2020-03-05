extends Stretch_Grid

var ready_label = load("res://Screens/Components/Ready_Label.tscn")

func _ready() -> void:
	Global.connect("game_state_changed", self, "_on_game_state_changed")
	_on_game_state_changed()

func _on_game_state_changed() -> void:
	for child in get_children():
		child.queue_free()
	
	for player in Global.game_state.keys():
		create_ready_label(Global.game_state[player]['name'])

func create_ready_label(text : String) -> void:
	var instance = ready_label.instance()
	add_child(instance)
	instance.text = text
