extends Node

var music_player := AudioStreamPlayer.new()
var now_playing := ""

func _ready() -> void:
	add_child(music_player)
	music_player.bus = "Music"
	
func set_mute(is_muted: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), is_muted)

func change_music(music_file, volume := 0.0, seek_to := 0) -> void:
	if now_playing != music_file:
		now_playing = music_file
		music_player.stream = load(music_file)
		music_player.volume_db = volume
		music_player.play()
		music_player.seek(seek_to)

func play_sfx(sound_file, volume := 0.0, pitch_scale := 1.0) -> void:
	var sfx_player := AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.bus = "SFX"
	sfx_player.stream = load(sound_file)
	sfx_player.volume_db = volume
	sfx_player.set_pitch_scale(pitch_scale)
	sfx_player.play()
	sfx_player.connect("finished", sfx_player, "queue_free")
