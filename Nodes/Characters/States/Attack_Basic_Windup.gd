extends PlayerState


func enter(_msg := {}):
	#.enter(_msg)
	if Input.is_action_pressed("charge") and player.charge_controller.charge_points > 0:
		player.in_charged_attack = true
		player.attack_count = 4
		player.charge_controller._on_charged_action()
		timer.set_wait_time(player.charged_windup_time)
	else:
		player.in_charged_attack = false
		timer.set_wait_time(player.windup_time)
	animationPlayer.play("Attack_Basic" + str(player.attack_count)+"_Windup")
	timer.start()


# Check if attack is canceled (das selbe steht schon im physics_update)
#func update(delta):
#	# Action can be cancelled (not by moving)
#	if Input.is_action_just_pressed("jump"):
#		state_machine.transition_to("Jump")
#	elif Input.is_action_pressed("block"):
#		state_machine.transition_to("Block_Windup")
#	elif Input.is_action_just_pressed("dash") and player.can_dash:
#		state_machine.transition_to("Dash")
#	else:
#		state_machine.transition_to("Attack_Basic") #NOO

# Check if attack is canceled (only if it isn't charged)
func physics_update(delta):
	
	if not player.in_charged_attack:
		player.move(delta) #attack_move here?

		# Action can be cancelled (not by moving)
#		if not player.is_on_floor():
#			state_machine.transition_to("Fall")
		if Input.is_action_just_pressed("jump") and player.is_on_floor():
			state_machine.transition_to("Jump")
		elif Input.is_action_pressed("block"):
			state_machine.transition_to("Block_Windup")
		elif Input.is_action_just_pressed("dash") and player.can_dash:
			state_machine.transition_to("Dash")


func _on_timeout():
	var input = player.pop_combat_queue()
	if player.in_charged_attack or input == player.PossibleInput.ATTACK_BASIC or player.PossibleInput.ATTACK_AIR:
		state_machine.transition_to("Attack_Basic")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
	else:
		player.last_input.clear()
		state_machine.transition_to("Idle")
