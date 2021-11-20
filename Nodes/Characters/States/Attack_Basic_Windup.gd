extends PlayerState


func enter(_msg := {}):
	.enter(_msg)
	timer.set_wait_time(player.windup_time)
	timer.start()


# Check if attack is canceled
func update(delta):
	# Action can be cancelled (not by moving)
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("block"):
		state_machine.transition_to("Block_Windup")
	elif Input.is_action_just_pressed("dash")  and player.can_dash:
		state_machine.transition_to("Dash")


func physics_update(delta):
	player.move(delta)


func _on_timeout():
	var input = player.pop_combat_queue()
	if input == null:
		state_machine.transition_to("Idle")
	elif input == player.PossibleInput.ATTACK_BASIC:
		state_machine.transition_to("Attack_Basic")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
