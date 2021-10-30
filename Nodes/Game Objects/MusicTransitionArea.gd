class_name MusicTransitionArea
extends Area2D


func _on_MusicTransitionArea_body_entered(body):
	MusicController.start_tracking(body, self)
	#MusicController.change_soundtrack(MusicController.SoundtrackTypes.MUSIC_CALM, "res://Nodes/Experimental/Placeholder/Sea_levelhectic_Demo_1.mp3")


func _on_MusicTransitionArea_body_exited(body):
	MusicController.stop_tracking()
	#pass
