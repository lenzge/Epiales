extends PlayerState


func physics_update(delta):
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return

	player.move(delta)

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Basic_Windup")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")
	elif is_equal_approx(player.get_direction(), 0.0):
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("dash")  and player.can_dash:
		state_machine.transition_to("Dash")

