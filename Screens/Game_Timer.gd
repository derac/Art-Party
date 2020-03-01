extends Label

var time_left = 90

signal game_timer_expired

func _ready():
	text = time_format(time_left)

static func time_format(time : int) -> String:
	var minutes = time / 60
	var seconds = time % 60
	return "%01d:%02d" % [minutes, seconds]

func _on_Countdown_timeout():
	time_left -= 1
	text = time_format(time_left)
	if time_left == 0:
		emit_signal("game_timer_expired")
		$Countdown.stop()

func stop() -> void:
	text = "1:30"
	$Countdown.stop()

func reset() -> void:
	time_left = 90
	$Countdown.start()
