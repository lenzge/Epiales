extends PlayerState



func enter(_msg := {}):
	_enter()
	player.velocity = Vector2.ZERO
	timer = get_tree().create_timer(player.block_time)
	yield(timer, "timeout")
	
	if timer_early_exit: # if the attack was canceled
		return
	
	state_machine.transition_to("Block_Recovery")


func update(delta):
	# Action can't be cancelled
	pass

func exit():
	timer_early_exit = true
