extends Control

var player_id : int setget set_player_id
var display_turn := 1
var scores := {}

const score_game = preload("res://Scripts/Utility/score_game.gd")

func set_player_id(value : int) -> void:
	player_id = value
	scores = score_game.calculate_stack(Global.game_state, player_id)
	display_turn = 0
	update_display(display_turn)
	display_turn += 1
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
	var played_by = Global.game_state[player_id]["played_by"][turn]
	if scores[played_by]:
		Sound.play_sfx("res://Assets/SFX/complete.wav", 0.0, 0.5)
		$Controls/Points.text = "+" + String(scores[played_by])
		$Controls/Points.set_visible(true)
	else:
		$Controls/Points.set_visible(false)
	$Controls/Turn.text = String(turn) + ". " + Global.game_state[played_by]["name"]

	if turn % 2:
		$Canvas.history = Global.game_state[player_id]["cards"][turn]
		$Canvas.redraw()
		$Controls/Word.text = Global.game_state[player_id]["cards"][turn - 1]
	else:
		$Controls/Word.text = Global.game_state[player_id]["cards"][turn]



