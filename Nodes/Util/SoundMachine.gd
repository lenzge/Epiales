class_name SoundMachine
extends Node2D


var rng : RandomNumberGenerator = RandomNumberGenerator.new()

signal sound_finished

func _ready():
	rng.randomize()
	for item in self.get_children():
		if item is AudioStreamPlayer or item is AudioStreamPlayer2D:
			item.connect("finished", self, "sound_finished")


# Start a sound and loop it if needed
func play_sound(sound: String, loop: bool) -> void:
	if is_sound_available(sound):
		var node = get_node(sound)
		var st = node.stream
		
		# MP3 and OGG
		if node.stream is AudioStreamMP3 or node.stream is AudioStreamOGGVorbis:
			node.stream.loop = loop
		# WAV
		else:
			if loop:
				node.stream.loop_mode = AudioStreamSample.LOOP_FORWARD
				node.stream.loop_end = node.stream.get_length() * node.stream.mix_rate
			else:
				node.stream.loop_mode = AudioStreamSample.LOOP_DISABLED
		
		node.play()
		
	else:
		print("[SoundMachine] Could not play sound '", sound, "': Sound not found")


# Stop a (looped) sound
func stop_sound(sound: String) -> void:
	if is_sound_available(sound):
		var node : AudioStreamPlayer2D = get_node(sound)
		node.stop()
	else:
		print("[SoundMachine] Could not stop sound '", sound, "': Sound not found")


func randomize_level(sound, min_level, max_level):
	if is_sound_available(sound):
		var node : AudioStreamPlayer2D = get_node(sound)
		node.volume_db = rng.randf_range(min_level, max_level)
	else:
		print("[SoundMachine] Could not randomize level of '", sound, "': Sound not found")


func randomize_pitch(sound, min_pitch, max_pitch):
	if is_sound_available(sound):
		var node : AudioStreamPlayer2D = get_node(sound)
		node.pitch_scale = rng.randf_range(min_pitch, max_pitch)
	else:
		print("[SoundMachine] Could not randomize pitch of '", sound, "': Sound not found")


func get_random(min_num: int, max_num: int) -> int:
	return rng.randi_range(min_num, max_num)


func is_sound_available(sound: String) -> bool:
	if has_node(sound):
		return true
	else:
		return false


func sound_finished():
	emit_signal("sound_finished")
