extends PlayerState

func enter(_msg := {}):
	if player.in_charged_attack:
		player.attack_count = 4
	else:
		player.sound_machine.play_sound("Sword Swing " + str(player.sound_machine.get_random(1, 2)), false)
		player.sound_machine.play_sound("Attack Grunt " + str(player.sound_machine.get_random(1, 8)), false)
	
	animationPlayer.play("Attack_Basic" + str(player.attack_count))
	.animation_to_timer()
	player.hitbox_attack.get_child(0).disabled = false
	player.hitbox_attack.knockback_force = player.attack_force[player.attack_count -1]
	player.hitbox_attack.knockback_time = player.attack_knockback[player.attack_count -1]


func physics_update(delta):
	if player.is_on_floor():
		player.attack_move(delta)
	else:
		player.attack_updown_air_move(delta)


func exit():
	.exit()
	player.hitbox_attack.get_child(0).disabled = true
	player.in_charged_attack = false
	if not state_machine.new_state == "Attack_Basic_Windup" or state_machine.new_state == "Attack_Basic_Recovery":
		player.attack_count = 1
		player.last_input.clear()


func _on_timeout():
	var input = player.last_input.back()
	if player.attack_count < player.max_attack_combo and (input == player.PossibleInput.ATTACK_BASIC or input == player.PossibleInput.ATTACK_AIR):
		player.attack_count += 1
		state_machine.transition_to("Attack_Basic_Windup")
#	elif input == player.PossibleInput.BLOCK:
#		player.pop_combat_queue()
#		state_machine.transition_to("Block_Windup")
	else:
		state_machine.transition_to("Attack_Basic_Recovery")
