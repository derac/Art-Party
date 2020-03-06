extends Label

const MAX_TIME = 2
var time_left := MAX_TIME
signal game_timer_expired

func _ready():
	text = time_format(time_left)

func _on_Countdown_timeout():
	time_left -= 1
	text = time_format(time_left)
	if time_left == 0:
		emit_signal("game_timer_expired")
		$Countdown.stop()
	elif time_left <= 10:
		Sound.play_sfx("res://Assets/SFX/button1.wav", 0.0, 10 / time_left)

func stop() -> void:
	$Countdown.stop()

func reset() -> void:
	time_left = MAX_TIME
	$Countdown.start()

static func time_format(time : int) -> String:
	var minutes = time / 60
	var seconds = time % 60
	return "%01d:%02d" % [minutes, seconds]
