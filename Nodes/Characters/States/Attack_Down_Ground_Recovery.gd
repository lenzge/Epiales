extends PlayerState


func enter(msg :={}):
	.enter(msg)
	.animation_to_timer()


func physics_update(delta):
	player.crouch_move(delta)


func _on_timeout():
	state_machine.transition_to("Crouch")
