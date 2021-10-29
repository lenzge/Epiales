extends Node

const VOLUME_RANGE : float = 80.0

var player : Player = null
var player_last_position : float
var transition_area_width : float
var tracking_direction : int # 0 = from left to right; 1 = from right to left
var previous_active_music : AudioStreamPlayer


# TODO: Commenting
# TODO: Collision Layers and Masks
# TODO: load_different soundtracks


func _process(delta):
	track_player()


func track_player():
	
	if player != null:
		var player_distance = player.position.x - player_last_position
		player_last_position = player.position.x
		
		var volume_adjustement = (player_distance / transition_area_width) * VOLUME_RANGE
		
		if previous_active_music == $Calm_music:
			tracking_adjust_volume($Calm_music, $Hectic_music, volume_adjustement)
		elif previous_active_music == $Hectic_music:
			tracking_adjust_volume($Hectic_music, $Calm_music, volume_adjustement)


func start_tracking(body: Player, music_transition_area: MusicTransitionArea) -> void:
	player = body
	player_last_position = body.position.x
	transition_area_width = music_transition_area.scale.x * 2
	
	if body.position.x < music_transition_area.position.x:
		tracking_direction = 0
	elif body.position.x > music_transition_area.position.x:
		tracking_direction = 1
	
	if $Hectic_music.stream_paused:
		$Hectic_music.stream_paused = false
		previous_active_music = $Calm_music
	elif $Calm_music.stream_paused:
		$Calm_music.stream_paused = false
		previous_active_music = $Hectic_music


func stop_tracking() -> void:
	player = null
	
	# reset the volumes and pause the not wanted music stream
	if $Calm_music.volume_db > $Hectic_music.volume_db:
		$Calm_music.volume_db = 0
		$Hectic_music.volume_db = -80
		$Hectic_music.stream_paused = true
	elif $Hectic_music.volume_db > $Calm_music.volume_db:
		$Hectic_music.volume_db = 0
		$Calm_music.volume_db = -80
		$Calm_music.stream_paused = true


func tracking_adjust_volume(music_old: AudioStreamPlayer, music_new: AudioStreamPlayer, volume_adjustement: float) -> void:
	
	if tracking_direction == 0:
		music_old.volume_db -= volume_adjustement
		music_new.volume_db += volume_adjustement
		print(volume_adjustement)
	elif tracking_direction == 1:
		music_old.volume_db += volume_adjustement
		music_new.volume_db -= volume_adjustement
