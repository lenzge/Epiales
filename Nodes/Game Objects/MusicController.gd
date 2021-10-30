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


func _ready():
	if is_active:
		
		# load soundtracks
		var calm_audio_stream = load(calm_music_path)
		var hectic_audio_stream = load(hectic_music_path)
		
		$Calm_music.stream = calm_audio_stream
		$Hectic_music.stream = hectic_audio_stream
		
		# initializing the tracks
		$Calm_music.play()
		$Hectic_music.play()
		
		if starting_track == SoundtrackTypes.MUSIC_CALM:
			$Hectic_music.stream_paused = true
			$Hectic_music.volume_db = -VOLUME_RANGE
		elif starting_track == SoundtrackTypes.MUSIC_HECTIC:
			$Calm_music.stream_paused = true
			$Calm_music.volume_db = -VOLUME_RANGE


func _process(delta):
	if is_active:
		track_player()


func track_player():
	
	# track the players movement and calculate the volume adjustement based on it
	if player != null:
		var player_distance = player.position.x - player_last_position
		player_last_position = player.position.x
		
		var volume_adjustement = (player_distance / transition_area_width) * VOLUME_RANGE
		
		if previous_active_music == $Calm_music:
			tracking_adjust_volume($Calm_music, $Hectic_music, volume_adjustement)
		elif previous_active_music == $Hectic_music:
			tracking_adjust_volume($Hectic_music, $Calm_music, volume_adjustement)


func start_tracking(body: Player, music_transition_area: MusicTransitionArea) -> void:
	# init tracking data
	player = body
	player_last_position = body.position.x
	transition_area_width = (music_transition_area.scale.x * 2) + (body.get_node("CollisionShape2D").get_shape().extents.x * 2)
	
	# start the paused Soundtrack
	if $Hectic_music.stream_paused:
		$Hectic_music.stream_paused = false
		previous_active_music = $Calm_music
	elif $Calm_music.stream_paused:
		$Calm_music.stream_paused = false
		previous_active_music = $Hectic_music


func stop_tracking() -> void:
	player = null
	volume_change = 0.0
	
	# reset the volumes and pause the not wanted soundtrack
	if $Calm_music.volume_db > $Hectic_music.volume_db:
		$Calm_music.volume_db = 0
		$Hectic_music.volume_db = -VOLUME_RANGE
		$Hectic_music.stream_paused = true
	elif $Hectic_music.volume_db > $Calm_music.volume_db:
		$Hectic_music.volume_db = 0
		$Calm_music.volume_db = -VOLUME_RANGE
		$Calm_music.stream_paused = true


func tracking_adjust_volume(music_old: AudioStreamPlayer, music_new: AudioStreamPlayer, volume_adjustement: float) -> void:
	
	volume_change += volume_adjustement
	
	# adjust the volumes, but with nonlinearity
	music_old.volume_db = - (pow(abs(volume_change) / VOLUME_RANGE, interpolation_damper) * VOLUME_RANGE)
	music_new.volume_db = - ((pow((VOLUME_RANGE - abs(volume_change)) / VOLUME_RANGE, interpolation_damper) * VOLUME_RANGE))



func change_soundtrack(type, track_path: String) -> void:
	var audio_stream = load(track_path)
	
	if type == SoundtrackTypes.MUSIC_HECTIC:
		$Hectic_music.stop()
		$Hectic_music.stream = audio_stream
		$Hectic_music.play()
	elif type == SoundtrackTypes.MUSIC_CALM:
		$Calm_music.stop()
		$Calm_music.stream = audio_stream
		$Calm_music.play()
