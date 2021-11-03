extends PlayerState


func enter(_msg := {}):
	_enter()
	player.velocity = Vector2.ZERO
	
	timer = get_tree().create_timer(player.recovery_time)
	yield(timer, "timeout")
	
	state_machine.transition_to("Idle")
