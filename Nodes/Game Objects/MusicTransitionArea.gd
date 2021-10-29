class_name MusicTransitionArea
extends Area2D


func _on_MusicTransitionArea_body_entered(body):
	MusicController.start_tracking(body, self)


func _on_MusicTransitionArea_body_exited(body):
	MusicController.stop_tracking()
