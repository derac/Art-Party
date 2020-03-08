extends Stretch_Grid

const ready_label = preload("res://Screens/Components/Ready_Label.tscn")
onready var Need_Players := get_node("../Need_Players")

func _ready() -> void:
	Global.connect("game_state_changed", self, "_on_game_state_changed")
	_on_game_state_changed()

func _on_game_state_changed() -> void:
	for child in get_children():
		child.queue_free()
	
	var player_num := Global.game_state.size()
	if player_num < 4:
		if OS.is_debug_build():
			Need_Players.text = "Debug build, less than 4 players allowed."
		else:
			Need_Players.text = "Need " + String(4 - player_num) + " more players to start."
		Need_Players.set_visible(true)
	else:
		Need_Players.set_visible(false)
	
	for player in Global.game_state.keys():
		create_ready_label(Global.game_state[player]['name'])

func create_ready_label(text : String) -> void:
	var instance = ready_label.instance()
	add_child(instance)
	instance.text = text
