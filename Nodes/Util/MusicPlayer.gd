class_name MusicPlayer
extends AudioStreamPlayer

export var empty_ms : int = 500
export var fade_step : float = 1.0

var loaded : bool = false

var can_unloaded : bool = false
var is_looping : bool = false setget set_is_looping, get_is_looping
var fade_out : bool = false
var fade_in : bool = false
var fade_to : bool = false
var fade_to_value : float = 0.0

var beats : int = 0


func _init(path: String):
	#load the music in here and set it as its own stream
	var music_stream = load(path)
	
	if music_stream != null:
		self.stream = music_stream
		self.volume_db = 0
		self.pitch_scale = 1
		self.bus = "Music"
	else:
		print("[MusicPlayer] Could not load music: ", path)
		loaded = false
		return
	
	loaded = true


func _process(delta):
	
	if fade_out:
		self.volume_db -= fade_step
		if self.volume_db <= -80:
			fade_out = false
			self.stop()
	
	if fade_in:
		self.volume_db += fade_step
		if self.volume_db >= 0:
			fade_in = false
	
	if fade_to:
		if self.volume_db > fade_to_value:
			self.volume_db -= fade_step
			if self.volume_db < fade_to_value:
				self.volume_db = fade_to_value
		elif self.volume_db < fade_to_value:
			self.volume_db += fade_step
			if self.volume_db > fade_to_value:
				self.volume_db = fade_to_value
		else:
			fade_to = false


func count_beat():
	beats += 1


func stop():
	.stop()
	beats = 0


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


func set_fade_to(fading_to_value: float):
	if fading_to_value > -80 and fading_to_value < 12:
		fade_to = true
		fade_to_value = fading_to_value


func unload() -> bool:
	if can_unloaded:
		return true
	else:
		return false
