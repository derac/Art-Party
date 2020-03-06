extends Control

var player_id : int setget set_player_id
var ids := Global.game_state.keys()
var player_id_index : int
var display_turn := 1

func set_player_id(value : int) -> void:
	display_turn = 1
	player_id = value
	player_id_index = ids.find(player_id)
	visible = true
	update_display(display_turn)

func _on_Back_pressed() -> void:
	if display_turn > 1:
		Sound.play_sfx("res://Assets/SFX/button1.wav", -3.0, 0.5)
		update_display(display_turn - 1)

func _on_Forward_pressed() -> void:
	if display_turn < Global.game_state[player_id]["cards"].size() - 1:
		Sound.play_sfx("res://Assets/SFX/button1.wav", -3.0, 2.0)
		update_display(display_turn + 1)

func update_display(turn : int) -> void:
	display_turn = turn
	$Controls/Turn.text = String(turn) + ". " + Global.game_state[ids[(player_id_index + turn - 1) % ids.size()]]["name"]
	if turn % 2:
		$Controls/Title.text = Global.game_state[player_id]["cards"][turn - 1]
		$Canvas.history = Global.game_state[player_id]["cards"][turn]
		$Canvas.redraw()
	else:
		$Controls/Title.text = Global.game_state[player_id]["cards"][turn]
		$Canvas.history = Global.game_state[player_id]["cards"][turn - 1]
		$Canvas.redraw()
