extends PlayerState

func enter(_msg := {}):
	_enter()
	player.velocity.y = -player.jump_impulse
	
func physics_update(delta):
	player.move(delta)

	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")

