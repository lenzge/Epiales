extends PlayerState

# Player is in Fall state, when he is in air and doesn't do more then moving

# Movement and checking for escape conditions
func physics_update(delta):
	
	# Can move left and right
	player.move(delta)
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
		player.sound_machine.play_sound("Landing", false)
	elif player.can_hang_on_wall and player.can_change_to_wallhang():
		if Input.is_action_pressed("hang_on_wall"):
			state_machine.transition_to("Wall_Hang")
		if Input.is_action_just_pressed("jump"):
			state_machine.transition_to("Wall_Jump")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
			state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("move_up"):
			state_machine.transition_to("Attack_Up_Windup")
		elif Input.is_action_pressed("move_down"):
			state_machine.transition_to("Attack_Down_Windup")
		else:
			state_machine.transition_to("Attack_Basic")
