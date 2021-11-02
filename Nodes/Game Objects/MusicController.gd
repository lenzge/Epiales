extends Node

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


func _ready():
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


func _process(delta):
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
	transition_area_width = ((music_transition_area.scale.x * 2) + 
			(body.get_node("CollisionShape2D").get_shape().extents.x * 2))
	
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
