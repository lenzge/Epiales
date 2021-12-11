class_name SoundMachine
extends Node2D


func _ready():
	pass # Replace with function body.


# Start a sound and loop it if needed
func play_sound(sound: String, loop: bool) -> void:
	if is_sound_available(sound):
		var node : AudioStreamPlayer2D = get_node(sound)
		node.stream.loop = loop
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


func is_sound_available(sound: String) -> bool:
	if has_node(sound):
		return true
	else:
		return false
