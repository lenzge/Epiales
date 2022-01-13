extends PlayerState

func enter(msg :={}):
	if abs(player.velocity.x) > 100:
		animationPlayer.play("Slide")
	elif state_machine.last_state.name == "Attack_Down_Recovery":
		animationPlayer.play("Crouch")
	else:
		animationPlayer.play("Crouch_Start")


func exit():
	.exit()


func physics_update(delta):
	
	if abs(player.velocity.x) > 100:
		animationPlayer.play("Slide")
	elif animationPlayer.current_animation == "Slide":
		animationPlayer.play("Slide_Crouch")
	
	player.decelerate_move_ground(delta, true)
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Windup")
	elif !Input.is_action_pressed("move_down") and not player.last_movement_buttons.empty():
		state_machine.transition_to("Run")
	elif !Input.is_action_pressed("move_down"):
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")

	
