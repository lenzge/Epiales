class_name MusicPlayer
extends AudioStreamPlayer


var loaded : bool = false

var can_unloaded : bool = false
var is_looping : bool = false setget set_is_looping, get_is_looping


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


func set_is_looping(loop: bool) -> void:
	# MP3 and OGG
	if self.stream is AudioStreamMP3 or self.stream is AudioStreamOGGVorbis:
		self.stream.loop = loop
	# WAV
	else:
		if loop:
			self.stream.loop_mode = AudioStreamSample.LOOP_FORWARD
			self.stream.loop_end = self.stream.get_length() * self.stream.mix_rate
		else:
			self.stream.loop_mode = AudioStreamSample.LOOP_DISABLED


func get_is_looping() -> bool:
	return is_looping


func unload() -> bool:
	if can_unloaded:
		return true
	else:
		return false
