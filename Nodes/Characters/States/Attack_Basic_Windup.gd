extends PlayerState


func enter(_msg := {}):
	if Input.is_action_pressed("charge") and player.charge_controller.has_charge() and player.is_on_floor():
		player.charge()
		player.sound_machine.play_sound("Charged Attack", false)
	else:
		player.in_charged_attack = false
	animationPlayer.play("Attack_Basic" + str(player.attack_count)+"_Windup")
	.animation_to_timer()
	player.attack_direction = player.direction


func physics_update(delta):
	
	if not player.in_charged_attack:
		if player.is_on_floor():
			player.move(delta)
		else:
			player.air_attack_move(delta)
			
		# Action can be cancelled (not by moving)
		if Input.is_action_just_pressed("jump") and player.is_on_floor():
			state_machine.transition_to("Jump")
		elif Input.is_action_pressed("block"):
			state_machine.transition_to("Block_Windup")


func exit():
	.exit()
	# Break the Attack chain, if cancelled
	if not state_machine.new_state == "Attack_Basic":
		player.attack_count = 1
		player.last_input.clear()


func _on_timeout():
	var input = player.pop_combat_queue()
	if player.in_charged_attack or input == player.PossibleInput.ATTACK_BASIC or player.PossibleInput.ATTACK_AIR:
		state_machine.transition_to("Attack_Basic")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
	else:
		player.last_input.clear()
		state_machine.transition_to("Idle")
	
