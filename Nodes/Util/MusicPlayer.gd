class_name MusicPlayer
extends AudioStreamPlayer

var loaded : bool = false

var can_unloaded : bool = false
var is_looping : bool = false

func _init(path: String):
	#load the music in here and set it as its own stream
	var music_stream = load(path)
	
	if music_stream != null:
		self.stream = music_stream
		self.volume_db = 0
		self.pitch_scale = 1
	else:
		print("[MusicPlayer] Could not load music: ", path)
		loaded = false
		return
	
	loaded = true


func unload() -> bool:
	if can_unloaded:
		return true
	else:
		return false
