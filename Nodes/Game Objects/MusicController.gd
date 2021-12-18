extends Node

###### New verision ######

#####   TODO   #####
#
# - Counting BPM
# - Starting scheduled music
#
##### END TODO #####

#######   Notices   ######
#### Every music is stored in the same folder -> therefore when loading a clip
#### we only need the name of the music clip
####
#### The BPM is controlled in this class
####### END NOTICES ######

export var SAMPLE_RATE : int = 44_100
export var BPM : int = 120

const USECS_PER_SECOND : int = 1_000_000
const MSECS_PER_SECOND : int = 1_000
const MUSIC_BASE_PATH : String = "res://Assets/Music/"

var thread : Thread
var running : bool = true

var usecs_per_update : float = 0
var current_time : int = 0
var last_update : int = 0

var music_loaded = {}
var music_scheduled = {}
var music_playing = []


class ScheduleData:
	var scheduled_in : int
	var scheduled_at : int
	
	func _init(schedule_in: int, schedule_at: int):
		scheduled_in = schedule_in
		scheduled_at = schedule_at


func _ready():
	usecs_per_update = (1.0 / SAMPLE_RATE) * USECS_PER_SECOND
	thread = Thread.new()
	thread.start(self, "_thread_loop")


func _thread_loop():
	running = true
	
	var update_counter : int = 0
	current_time = OS.get_ticks_usec()
	last_update = OS.get_ticks_usec()
	
	while running:
		
		if !music_playing.empty():
			# The start_time is the time the loop iteration started
			var start_time = OS.get_ticks_usec()
			
			# count updates (sample rate)
			if start_time >= last_update + usecs_per_update:
				# last update is the start_time minus the difference between when the start_time should have happened to the actual start_time
				last_update = start_time - (start_time - (last_update + usecs_per_update)) # = start_time when it should have happened
				update_counter += 1
			
			# count seconds and print done updates
			if last_update >= current_time + USECS_PER_SECOND:
				print(update_counter)
				update_counter = 0
				# current time is the start_time minus the difference between when the start_time should have happened to the actual start_time
				current_time = start_time - (start_time - (current_time + USECS_PER_SECOND)) # = start_time when it should have happened


func play_music(music_name: String) -> bool:
	# Test if the music is loaded, if not try to load it
	if music_name in music_loaded or load_music(music_name):
		schedule_music(music_name, 0) # 0 means play as soon as possible
		return true
	
	return false


func schedule_music(music_name: String, beats: int) -> bool:
	# Test if the music is loaded, if not try to load it
	var time_in_usec = 0
	if music_name in music_loaded or load_music(music_name):
		var schedule_data = ScheduleData.new(time_in_usec, OS.get_ticks_usec()) # TODO: Change second parameter to last_update
		music_scheduled[music_name] = schedule_data
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
export var is_active : bool = false

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
