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
	elif player.is_on_wall():
		if Input.is_action_just_pressed("jump"):
			if player.get_slide_collision(0).get_position().x > player.position.x:
				player.velocity.x = -10 * player.speed
			else:
				player.velocity.x = 10 * player.speed
			player.velocity.y = -player.jump_impulse

