extends PlayerState

# Play short animations depending on the last state before playing idle animation
func enter(_msg := {}):
	if state_machine.last_state.name == "Jump" or state_machine.last_state.name == "Fall":
		animationPlayer.play("Jump_landing")
	elif state_machine.last_state.name == "Dash" and player.is_on_floor():
		animationPlayer.play("Run_Turn")
	elif state_machine.last_state.name == "Crouch":
		animationPlayer.play("Crouch_End")
	else:
		.enter(_msg)
		animationPlayer.set_speed_scale(animationPlayer.idle_speed)
	

func update(delta):
	
	# For smooth deceleration after moving
	player.decelerate_move_ground(delta)
	 
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return
	
	if Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("move_up"):
			state_machine.transition_to("Attack_Up_Windup")
		else:
			state_machine.transition_to("Attack_Basic_Windup")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif not player.last_movement_buttons.empty():
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
	elif Input.is_action_pressed("move_down"):
		state_machine.transition_to("Crouch")
