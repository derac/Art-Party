extends Control

var player_id : int setget set_player_id
var ids := Global.game_state.keys()
var player_id_index : int
var display_turn := 1

func set_player_id(value : int) -> void:
	display_turn = 1
	player_id = value
	player_id_index = ids.find(player_id)
	update_display(display_turn)
	Sound.play_sfx("res://Assets/SFX/button2.wav", 0, 1.5)	
	visible = true

func _on_Back_pressed() -> void:
	if display_turn > 1:
		Sound.play_sfx("res://Assets/SFX/off.wav", 0, 2)
		update_display(display_turn - 1)

func _on_Forward_pressed() -> void:
	if display_turn < Global.game_state[player_id]["cards"].size() - 1:
		Sound.play_sfx("res://Assets/SFX/on.wav", 0, 1.5)
		update_display(display_turn + 1)

func _on_Return_pressed():
	Sound.play_sfx("res://Assets/SFX/button1.wav", 0, 0.75)
	visible = false
	$Canvas.history = [[]]
	$Canvas.redraw()
	
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



