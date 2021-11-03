extends PlayerState



func enter(_msg := {}):
	_enter()
	player.velocity = Vector2.ZERO
	timer_early_exit = false
	timer = get_tree().create_timer(player.recovery_time)
	yield(timer, "timeout")
	
	if timer_early_exit: # if the attack was canceled
		return
	
	state_machine.transition_to("Idle")


func update(delta):
	# Action can't be cancelled
	pass


