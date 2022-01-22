extends PlayerState


func enter(_msg := {}):
	if player.is_on_floor():
		animationPlayer.play("Attack_Down_Windup")
	else:
		animationPlayer.play("Attack_Down_Windup_Air")
	.animation_to_timer()


func physics_update(delta):
	if player.is_on_floor():
		player.decelerate_move_ground(delta, true)
	else:
		player.air_attack_move(delta)
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("block") and player.is_on_floor():
		state_machine.transition_to("Block_Windup")
	


func _on_timeout():
	var input = player.pop_combat_queue()
#	if input == null:
#		if player.is_on_floor():
#			state_machine.transition_to("Idle")
#		else:
#			state_machine.transition_to("Fall")
	if input == player.PossibleInput.ATTACK_BASIC or player.PossibleInput.ATTACK_AIR or null:
		state_machine.transition_to("Attack_Down")
	elif input == player.PossibleInput.BLOCK and player.is_on_floor():
		state_machine.transition_to("Block_Windup")
	else:
		state_machine.transition_to("Idle")
