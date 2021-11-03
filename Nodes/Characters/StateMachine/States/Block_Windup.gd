extends PlayerState



func enter(_msg := {}):
	_enter()
	player.velocity = Vector2.ZERO
	timer_early_exit = false
	timer = get_tree().create_timer(player.windup_time)
	yield(timer, "timeout")
	
	if timer_early_exit: # if the attack was canceled
		return
	
	player.pop_combat_queue()
	
	state_machine.transition_to("Block")


func update(delta):
	# Action can be cancelled (not by moving)
	
	if not player.is_on_floor():
		timer_early_exit = true
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		timer_early_exit = true
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("attack"):
		timer_early_exit = true
		state_machine.transition_to("Attack_Basic_Windup")


