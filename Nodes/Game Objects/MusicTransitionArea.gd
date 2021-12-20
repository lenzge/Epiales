class_name MusicTransitionArea
extends Area2D

enum TransitionTypes {PLAYER_TRACKING, FADE}

export(TransitionTypes) var transition_type = TransitionTypes.PLAYER_TRACKING


func _on_MusicTransitionArea_body_entered(body):
	if transition_type == TransitionTypes.PLAYER_TRACKING:
		music_controller.start_tracking(body, self)
	elif transition_type == TransitionTypes.FADE:
		music_controller.set_switching()
	#MusicController.change_soundtrack(MusicController.SoundtrackTypes.MUSIC_CALM, 
	#		"res://Nodes/Experimental/Placeholder/Sea_levelhectic_Demo_1.mp3")


func _on_MusicTransitionArea_body_exited(body):
	if transition_type == TransitionTypes.PLAYER_TRACKING:
		music_controller.stop_tracking()
