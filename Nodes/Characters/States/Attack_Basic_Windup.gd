extends PlayerState

func enter(_msg := {}):
	if Input.is_action_pressed("charge") and player.charge_controller.charge_points > 0:
		player.in_charged_attack = true
		player.attack_count = 4
		player.charge_controller._on_charged_action()
		player.sound_machine.play_sound("Charged Attack", false)
	else:
		player.in_charged_attack = false
	animationPlayer.play("Attack_Basic" + str(player.attack_count)+"_Windup")
	.animation_to_timer()

func physics_update(delta):
	
	if not player.in_charged_attack:
		if not player.is_on_floor():
			player.attack_updown_air_move(delta)
		else:
			player.move(delta) #attack_move here?
			
		# Action can be cancelled (not by moving)
#		if not player.is_on_floor():
#			state_machine.transition_to("Fall")
		if Input.is_action_just_pressed("jump") and player.is_on_floor():
			state_machine.transition_to("Jump")
		elif Input.is_action_pressed("block"):
			state_machine.transition_to("Block_Windup")
			
func _on_timeout():
	var input = player.pop_combat_queue()
	if player.in_charged_attack or input == player.PossibleInput.ATTACK_BASIC or player.PossibleInput.ATTACK_AIR:
		state_machine.transition_to("Attack_Basic")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
	else:
		player.last_input.clear()
		state_machine.transition_to("Idle")
