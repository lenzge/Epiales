extends PlayerState



func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	timer.set_wait_time(player.attack_time)
	timer.connect("timeout", self, "_stop_block_recovery")
	timer.start()




func update(delta):
	# Action can be cancelled (not by moving)
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("attack"):
		state_machine.transition_to("Attack_Basic_Windup")



func _stop_block_recovery():
	player.pop_combat_queue()
	state_machine.transition_to("Block")
