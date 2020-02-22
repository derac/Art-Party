extends Control

var player_id : int setget set_player_id
var display_turn := 1 setget set_display_turn

func set_player_id(value : int):
	player_id = value
	visible = true
	set_display_turn(1)

func set_display_turn(value : int):
	display_turn = value
	update_display()

func _on_Back_pressed():
	if display_turn > 1:
		set_display_turn(display_turn - 1)

func _on_Forward_pressed():
	if display_turn < Global.game_state[player_id]["cards"].size() - 1:
		set_display_turn(display_turn + 1)

func update_display():
	if display_turn % 2:
		$Title.text = Global.game_state[player_id]["cards"][display_turn - 1]
		$Canvas.history = Global.game_state[player_id]["cards"][display_turn]
		$Canvas.redraw()
	else:
		$Title.text = Global.game_state[player_id]["cards"][display_turn]
		$Canvas.history = Global.game_state[player_id]["cards"][display_turn - 1]
		$Canvas.redraw()
