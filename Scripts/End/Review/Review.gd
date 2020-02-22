extends Control

var player_id : int setget set_player_id
var display_turn := 1

func set_player_id(value : int):
	player_id = value
	visible = true
	update_display(1)

func _on_Back_pressed():
	if display_turn > 1:
		update_display(display_turn - 1)

func _on_Forward_pressed():
	if display_turn < Global.game_state[player_id]["cards"].size() - 1:
		update_display(display_turn + 1)

func update_display(turn : int):
	display_turn = turn
	$Turn.text = String(turn)
	if turn % 2:
		$Title.text = Global.game_state[player_id]["cards"][turn - 1]
		$Canvas.history = Global.game_state[player_id]["cards"][turn]
		$Canvas.redraw()
	else:
		$Title.text = Global.game_state[player_id]["cards"][turn]
		$Canvas.history = Global.game_state[player_id]["cards"][turn - 1]
		$Canvas.redraw()
