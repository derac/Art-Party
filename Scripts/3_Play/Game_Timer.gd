extends Label

const MAX_TIME := 90
var time_left := MAX_TIME
signal game_timer_expired

const stylebox = preload("res://Screens/Styles/Game_Timer.tres")

func _ready():
	if OS.is_debug_build():
		time_left = 3
	
	stylebox.set_border_color(Color("#FFA300"))
	text = time_format(time_left)

func _on_Countdown_timeout():
	time_left -= 1
	text = time_format(time_left)
	if time_left == 0:
		emit_signal("game_timer_expired")
		stylebox.set_border_color(Color("#83769C"))
		$Countdown.stop()
	elif time_left <= 10:
		if time_left == 3:
			stylebox.set_border_color(Color("#FF004D"))
		Sound.play_sfx("res://Assets/SFX/button1.wav", 0.0, 10 / time_left)

func stop() -> void:
	$Countdown.stop()

func reset() -> void:
	stylebox.set_border_color(Color("#FFA300"))
	time_left = MAX_TIME
	$Countdown.start()

static func time_format(time : int) -> String:
	var minutes = time / 60
	var seconds = time % 60
	return "%01d:%02d" % [minutes, seconds]
