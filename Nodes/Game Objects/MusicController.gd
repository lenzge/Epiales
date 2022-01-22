extends Node

const RANDOM_NUMBER : int = 1000

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var music_playing = []
var music_fade_out = {}
var music_fade_in = {}
var music_fade_in_at_random = {}

var all_available_music = {}

class MusicData:
	var original_volume : float
	func _init(p_original_volume: float):
		original_volume = p_original_volume

func _ready():
	rng.randomize()
	
	for player in self.get_children():
		var data = MusicData.new(player.volume_db)
		all_available_music[player.get_name()] = data


func _process(_delta):
	for music in music_fade_out:
		if get_node(music).volume_db >= -60:
			get_node(music).volume_db -= music_fade_out[music]
		else:
			get_node(music).volume_db = all_available_music[music].original_volume
			music_fade_out.erase(music)
			stop_music(music)
	
	for music in music_fade_in:
		if get_node(music).volume_db < all_available_music[music].original_volume:
			get_node(music).volume_db += music_fade_in[music]
		else:
			get_node(music).volume_db = all_available_music[music].original_volume
			music_fade_in.erase(music)
	
	for music in music_fade_in_at_random:
		if not music in music_playing and not music in music_fade_in:
			var random = rng.randi_range(0, RANDOM_NUMBER)
			if random == RANDOM_NUMBER:
				fade_in_music(music, music_fade_in_at_random[music])
				music_fade_in_at_random.erase(music)
		else:
			music_fade_in_at_random.erase(music)


func play_music(music_name: String) -> void:
	if not music_name in music_playing:
		get_node(music_name).play(0)
		music_playing.append(music_name)


func stop_music(music_name: String) -> void:
	if music_name in music_playing:
		get_node(music_name).stop()
		music_playing.erase(music_name)


func stop_everything(exceptions := []):
	for music in music_playing:
		if not music in exceptions:
			get_node(music).stop()
	music_playing.clear()
	music_fade_in.clear()
	music_fade_in_at_random.clear()


func fade_out_music(music_name: String, rate = 1.0):
	if music_name in music_playing and not music_name in music_fade_out:
		music_fade_out[music_name] = rate


func fade_out_everything(rate = 1.0):
	for music in music_playing:
		fade_out_music(music, rate)
	music_fade_in.clear()
	music_fade_in_at_random.clear()


func fade_in_music(music_name: String, rate = 1.0):
	if not music_name in music_playing:
		music_fade_in[music_name] = rate
		get_node(music_name).volume_db = -60
		play_music(music_name)


func fade_in_at_random(music_name: String, rate = 1.0):
	if not music_name in music_playing:
		music_fade_in_at_random[music_name] = rate


func set_music_volume(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Music")
	var eased_value = -Globals.VOLUME_DB_RANGE * pow(abs(value) / Globals.VOLUME_DB_RANGE, Globals.VOLUME_EASE_FACTOR)
	AudioServer.set_bus_volume_db(bus_idx, eased_value)


func get_music_volume() -> float:
	var bus_idx = AudioServer.get_bus_index("Music")
	var eased_value = AudioServer.get_bus_volume_db(bus_idx)
	return -Globals.VOLUME_DB_RANGE * pow(abs(eased_value) / Globals.VOLUME_DB_RANGE, 1 / Globals.VOLUME_EASE_FACTOR)


func set_sound_volume(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Sounds")
	var eased_value = -Globals.VOLUME_DB_RANGE * pow(abs(value) / Globals.VOLUME_DB_RANGE, Globals.VOLUME_EASE_FACTOR)
	AudioServer.set_bus_volume_db(bus_idx, eased_value)


func get_sound_volume() -> float:
	var bus_idx = AudioServer.get_bus_index("Sounds")
	var eased_value = AudioServer.get_bus_volume_db(bus_idx)
	return -Globals.VOLUME_DB_RANGE * pow(abs(eased_value) / Globals.VOLUME_DB_RANGE, 1 / Globals.VOLUME_EASE_FACTOR)

