extends PlayerState


func enter(msg :={}):
	.enter(msg)
	.animation_to_timer()


func physics_update(delta):
	player.attack_updown_air_move(delta)


func _on_timeout():
	state_machine.transition_to("Fall")
