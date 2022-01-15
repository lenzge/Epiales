extends PlayerState


func enter(msg :={}):
	.enter(msg)
	.animation_to_timer()


func physics_update(delta):
	# Movement depending on ground or air
	if player.is_on_floor():
		player.decelerate_move_ground(delta, true)
	else:
		player.fall_straight(delta)
		# Exception for better gameplay
		if Input.is_action_just_pressed("dash") and player.can_dash:
			state_machine.transition_to("Dash")

func _on_timeout():
	if player.is_on_floor():
		state_machine.transition_to("Crouch")
	else:
		state_machine.transition_to("Fall")
