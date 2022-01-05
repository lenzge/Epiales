extends PlayerState

func enter(_msg := {}):
	.enter(_msg)
	player.velocity.y = -player.jump_impulse
	player.sound_machine.play_sound("Jump", false)
	


func exit():
	player.add_jump_gravity_damper = false
	
	if player.is_on_floor():
		player.sound_machine.play_sound("Landing", false)


func update(delta):
	if Input.is_action_pressed("jump") and player.velocity.y < 0:
		player.add_jump_gravity_damper = true
	else:
		player.add_jump_gravity_damper = false


func physics_update(delta):
	player.move(delta)

	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("dash")  and player.can_dash:
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("move_up"):
			state_machine.transition_to("Attack_Up_Air_Windup")
		elif Input.is_action_pressed("move_down"):
			state_machine.transition_to("Attack_Down_Air_Windup")
		else:
			state_machine.transition_to("Attack_Basic_Windup")
	elif player.can_hang_on_wall and player.is_on_wall():
		if Input.is_action_pressed("hang_on_wall") and \
		player.velocity.y > player.wall_hang_min_entrance_y_velocity:
			state_machine.transition_to("Wall_Hang")
		elif Input.is_action_just_pressed("jump"):
			state_machine.transition_to("Wall_Jump")
	elif Input.is_action_pressed("move_up") and Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Up_Air_Windup")
	elif Input.is_action_pressed("move_down") and Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Air_Windup")
