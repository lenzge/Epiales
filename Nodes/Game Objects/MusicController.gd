extends Node

###### New verision ######

#######   Notices   ######
#### Every music is stored in the same folder -> therefore when loading a clip
#### we only need the name of the music clip
####
#### The BPM is controlled in this class
####### END NOTICES ######

export var SAMPLE_RATE : int = 44_100
export var BPM : int = 120

export var print_beats : bool = false
export var print_updates : bool = false
export var is_active : bool = false

const USECS_PER_SECOND : int = 1_000_000
const MSECS_PER_SECOND : int = 1_000
const MSEC_TO_USEC_FACTOR : int = 1_000
const MUSIC_BASE_PATH : String = "res://Assets/Music/"

var thread : Thread
var running : bool = true

var usecs_per_update : float = 0.0
var current_time : int = 0
var last_update : float = 0.0
var beat_timer : int = 0

var beats_per_second : float = 0.0
var seconds_per_beat : float = 0.0

var music_loaded = {}
var music_scheduled = {}
var music_playing = []

var beats = 0


class ScheduleData:
	var scheduled_in : int
	var scheduled_at : int
	
	func _init(schedule_in: int, schedule_at: int):
		scheduled_in = schedule_in
		scheduled_at = schedule_at
	
	func get_time_in_usec() -> int:
		return scheduled_at + scheduled_in
	
	func get_time_in_msec() -> float:
		return float(get_time_in_usec()) / MSEC_TO_USEC_FACTOR
	
	func get_time_in_seconds() -> float:
		return float(get_time_in_usec()) / USECS_PER_SECOND


func _ready():
	usecs_per_update = (1.0 / SAMPLE_RATE) * USECS_PER_SECOND
	beats_per_second = BPM / 60.0
	seconds_per_beat = 1.0 / beats_per_second
	if is_active:
		thread = Thread.new()
		thread.start(self, "_thread_loop")


func _thread_loop(userdata):
	running = true
	
	var update_counter : int = 0
	current_time = OS.get_ticks_usec()
	last_update = OS.get_ticks_usec()
	beat_timer = OS.get_ticks_usec()
	
	while running and is_active:
		
		# The start_time is the time the loop iteration started
		var start_time = OS.get_ticks_usec()
		
		# count updates (sample rate)
		if start_time >= last_update + usecs_per_update:
			# last update is the start_time minus the difference between when the start_time should have happened to the actual start_time
			last_update = start_time - (start_time - (last_update + usecs_per_update)) # = start_time when it should have happened
			update_counter += 1
			
			# start scheduled music
			if music_playing.empty() and !music_scheduled.empty():
				start_music(music_scheduled.keys()[0], start_time)
				beat_timer = start_time
			elif !music_scheduled.empty():
				for music_name in music_scheduled:
					start_music(music_name, start_time)
			
			# count beats
			if start_time >= (beat_timer + (seconds_per_beat * USECS_PER_SECOND)):
				beat_timer = start_time - (start_time - (beat_timer + (seconds_per_beat * USECS_PER_SECOND)))
				beats += 1
				for music_name in music_playing:
					get_node(music_name.replace(".", "")).count_beat()
				if print_beats:
					print(beats)
			
			# count seconds and print done updates
			if last_update >= current_time + USECS_PER_SECOND:
				if print_updates:
					print(update_counter)
				update_counter = 0
				# current time is the start_time minus the difference between when the start_time should have happened to the actual start_time
				current_time = start_time - (start_time - (current_time + USECS_PER_SECOND)) # = start_time when it should have happened


func get_time_to_next_beat_usec() -> int:
	return int((beat_timer + (seconds_per_beat * USECS_PER_SECOND)) - last_update)


func start_music(music_name: String, start_time: int) -> void:
	var clip = self.get_node(music_name.replace(".", ""))
	var schedule_data = music_scheduled[music_name]
	var start_playing_in = ((clip.empty_ms / MSECS_PER_SECOND) - ((schedule_data.get_time_in_usec() - start_time) / USECS_PER_SECOND)) + (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
	if start_playing_in > 0:
		clip.play(start_playing_in)
		music_playing.append(music_name)
		music_scheduled.erase(music_name)


func play_music(music_name: String) -> bool:
	# Test if the music is loaded, if not try to load it
	if music_name in music_loaded or load_music(music_name):
		if schedule_music(music_name, 1): # 1 means play at next beat
			return true
	
	return false


func schedule_music(music_name: String, beats: int) -> bool:
	# Test if the music is loaded, if not try to load it
	var time_in_usec = (((beats - 1) * seconds_per_beat) * USECS_PER_SECOND) + get_time_to_next_beat_usec()
	if music_name in music_loaded or load_music(music_name):
		var schedule_data = ScheduleData.new(time_in_usec, OS.get_ticks_usec())
		music_scheduled[music_name] = schedule_data
		return true
	
	return false


func stop_music(music_name: String) -> bool:
	if music_name in music_playing:
		get_node(music_name).stop()
		music_playing.erase(music_name)
		return true
	if music_name in music_scheduled:
		music_scheduled.erase(music_name)
		return true
	
	return false


func load_music(music_name: String) -> bool:
	
	# Test if music is already loaded
	if not music_name in music_loaded:
		
		# Test if file exists (base_path + music_name)
		var file = File.new()
		if file.file_exists(MUSIC_BASE_PATH + music_name):
			
			var music_player = MusicPlayer.new(MUSIC_BASE_PATH + music_name)
			if music_player.loaded:
				music_loaded[music_name] = music_player
				music_player.name = music_name
				self.add_child(music_player)
			else:
				music_player.queue_free()
				return false
			
		else:
			return false
	
	# If everything went good return true
	return true


func unload_music(music_name: String) -> void:
	# test if music can be unloaded (is it playing, is it scheduled)
	pass


func _exit_tree():
	running = false
	if is_active:
		thread.wait_to_finish()


##############################################################################################################

##############################################################################################################

############################################# Old version ####################################################

##############################################################################################################

##############################################################################################################


enum SoundtrackTypes {MUSIC_CALM, MUSIC_HECTIC}

const VOLUME_RANGE : float = 80.0

export var calm_music_path : String
export var hectic_music_path : String
export(SoundtrackTypes) var starting_track
export var interpolation_damper : float = 5.0

var player : Player = null
var player_last_position : float
var transition_area_width : float
var previous_active_music : AudioStreamPlayer
var volume_change : float = 0.0

var switching : bool = false

onready var node_calm_music : AudioStreamPlayer = $Calm_music
onready var node_hectic_music : AudioStreamPlayer = $Hectic_music


func _ready_old():
	if is_active:
		
		# load soundtracks
		var calm_audio_stream = load(calm_music_path)
		var hectic_audio_stream = load(hectic_music_path)
		
		node_calm_music.stream = calm_audio_stream
		node_hectic_music.stream = hectic_audio_stream
		
		# initializing the tracks
		node_calm_music.play()
		node_hectic_music.play()
		
		if starting_track == SoundtrackTypes.MUSIC_CALM:
			node_hectic_music.stream_paused = true
			node_hectic_music.volume_db = -VOLUME_RANGE
		elif starting_track == SoundtrackTypes.MUSIC_HECTIC:
			node_calm_music.stream_paused = true
			node_calm_music.volume_db = -VOLUME_RANGE


func _process_old(delta):
	if is_active:
		track_player()
		switch_soundtracks()


func track_player() -> void:
	
	# track the players movement and calculate the volume adjustement based on it
	if player != null:
		var player_distance = player.position.x - player_last_position
		player_last_position = player.position.x
		
		var volume_adjustement = (player_distance / transition_area_width) * VOLUME_RANGE
		
		if previous_active_music == node_calm_music:
			tracking_adjust_volume(node_calm_music, node_hectic_music, volume_adjustement)
		elif previous_active_music == node_hectic_music:
			tracking_adjust_volume(node_hectic_music, node_calm_music, volume_adjustement)


func start_tracking(body: Player, music_transition_area: MusicTransitionArea) -> void:
	# init tracking data
	player = body
	player_last_position = body.position.x
	transition_area_width = ((music_transition_area.scale.x * 2))
	
	# start the paused Soundtrack
	if node_hectic_music.stream_paused:
		node_hectic_music.stream_paused = false
		previous_active_music = node_calm_music
	elif node_calm_music.stream_paused:
		node_calm_music.stream_paused = false
		previous_active_music = node_hectic_music


func stop_tracking() -> void:
	player = null
	volume_change = 0.0
	
	# reset the volumes and pause the not wanted soundtrack
	if node_calm_music.volume_db > node_hectic_music.volume_db:
		node_calm_music.volume_db = 0
		node_hectic_music.volume_db = -VOLUME_RANGE
		node_hectic_music.stream_paused = true
	elif node_hectic_music.volume_db > node_calm_music.volume_db:
		node_hectic_music.volume_db = 0
		node_calm_music.volume_db = -VOLUME_RANGE
		node_calm_music.stream_paused = true


func tracking_adjust_volume(music_old: AudioStreamPlayer, music_new: AudioStreamPlayer,
		volume_adjustement: float) -> void:
	
	volume_change += volume_adjustement
	
	# adjust the volumes, but with non-linearity
	music_old.volume_db = - (pow(abs(volume_change) / VOLUME_RANGE,
			interpolation_damper) * VOLUME_RANGE)
	music_new.volume_db = - ((pow((VOLUME_RANGE - abs(volume_change)) / VOLUME_RANGE,
			interpolation_damper) * VOLUME_RANGE))


# load another soundtrack
func change_soundtrack(soundtrack_type, track_path: String) -> void:
	var audio_stream = load(track_path)
	
	if soundtrack_type == SoundtrackTypes.MUSIC_HECTIC:
		node_hectic_music.stop()
		node_hectic_music.stream = audio_stream
		node_hectic_music.play()
	elif soundtrack_type == SoundtrackTypes.MUSIC_CALM:
		node_calm_music.stop()
		node_calm_music.stream = audio_stream
		node_calm_music.play()


func set_switching() -> void:
	switching = true
	
	if node_hectic_music.stream_paused:
		node_hectic_music.stream_paused = false
		previous_active_music = node_calm_music
	elif node_calm_music.stream_paused:
		node_calm_music.stream_paused = false
		previous_active_music = node_hectic_music


# Switch soundtracks with simple fade in and fade out
func switch_soundtracks() -> void:
	if switching:
		
		if previous_active_music == node_calm_music:
			node_calm_music.volume_db -= 2
			node_hectic_music.volume_db += 2
			if node_hectic_music.volume_db == 0:
				switching = false
				node_calm_music.stream_paused = true
				
		elif previous_active_music == node_hectic_music:
			node_hectic_music.volume_db -= 2
			node_calm_music.volume_db += 2
			if node_calm_music.volume_db == 0:
				switching = false
				node_hectic_music.stream_paused = true
