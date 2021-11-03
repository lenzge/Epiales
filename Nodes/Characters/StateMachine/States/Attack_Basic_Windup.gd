extends PlayerState



func enter(_msg := {}):
	_enter()
	timer = get_tree().create_timer(player.windup_time)
	yield(timer, "timeout")
	
	
	if timer_early_exit: # if the attack was canceled
		return
	
	# Move to next state
	var input = player.pop_combat_queue()
	if input == null:
		state_machine.transition_to("Idle")
	elif input == player.PossibleInput.ATTACK_BASIC:
		state_machine.transition_to("Attack_Basic_1")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")


# Check if attack is canceled
func update(delta):
	# Action can be cancelled (not by moving)
	if not player.is_on_floor():
		timer_early_exit = true
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		timer_early_exit = true
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("block"):
		timer_early_exit = true
		state_machine.transition_to("Block_Windup")

func physics_update(delta):
	player.move(delta)
