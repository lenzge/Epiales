extends PlayerState

func enter(_msg := {}):
	.enter(_msg)
	player.velocity.y = -player.jump_impulse
	
func physics_update(delta):
	player.move(delta)

	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("dash")  and player.can_dash:
		state_machine.transition_to("Dash")
	elif player.can_hang_on_wall and player.is_on_wall():
		if Input.is_action_pressed("hang_on_wall") and \
				player.velocity.y > (-player.jump_impulse * player.wall_hang_max_entrance_y_velocity):
			state_machine.transition_to("Wall_Hang")
		elif Input.is_action_just_pressed("jump"):
			state_machine.transition_to("Wall_Jump")
