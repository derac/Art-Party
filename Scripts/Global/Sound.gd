extends Node

var music_player := AudioStreamPlayer.new()
var now_playing := ""

func _ready():
	add_child(music_player)
	music_player.bus = "Music"
	
func set_mute(is_muted: bool) -> void:
	if is_muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)

func change_music(music_file, seek_to := 0, volume := 0.0):
	if File.new().file_exists(music_file):
		if now_playing != music_file:
			now_playing = music_file
			music_player.stream = load(music_file)
			music_player.volume_db = volume
			music_player.play()
			music_player.seek(seek_to)

func play_sfx(sound_file):
	if File.new().file_exists(sound_file):
		var sfx_player := AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_player.bus = "SFX"
		sfx_player.stream = load(sound_file)
		sfx_player.stream.loop = false
		sfx_player.play()
		sfx_player.connect("finished", sfx_player, "queue_free")
