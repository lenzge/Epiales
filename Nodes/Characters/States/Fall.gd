extends PlayerState


func physics_update(delta):
	player.move(delta)
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		elif Input.is_action_just_pressed("dash") and player.can_dash:
			state_machine.transition_to("Dash")
		else:
			state_machine.transition_to("Run")

