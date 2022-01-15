extends PlayerState


func enter(msg :={}):
	.enter(msg)
	.animation_to_timer()
	
	# Enable the attack hitboxes depending on ground or air
	if player.is_on_floor():
		player.get_node("Attack_Up_Ground/HitboxAttack_Front").disabled = false
		player.get_node("Attack_Up_Ground/HitboxAttack_Top").disabled = false
		player.hitbox_up_attack.knockback_force = player.attack_force[0]
		player.hitbox_up_attack.knockback_time = player.attack_knockback[0]
	else:
		player.get_node("Attack_Up_Air/HitboxAttack").disabled = false
		player.hitbox_up_attack_air.knockback_force = player.attack_force[0]
		player.hitbox_up_attack_air.knockback_time = player.attack_knockback[0]
	
	player.sound_machine.play_sound("Sword Swing " + str(player.sound_machine.get_random(1, 2)), false)
	player.sound_machine.play_sound("Attack Grunt " + str(player.sound_machine.get_random(1, 7)), false)


func physics_update(delta):
	# Movement depending on ground or air
	if player.is_on_floor():
		player.decelerate_move_ground(delta)
	else:
		player.air_attack_move(delta)

# Disable the attack hitboxes
func exit():
	.exit()
	player.get_node("Attack_Up_Ground/HitboxAttack_Front").disabled = true
	player.get_node("Attack_Up_Ground/HitboxAttack_Top").disabled = true
	player.get_node("Attack_Up_Air/HitboxAttack").disabled = true

func _on_timeout():
	var input = player.pop_combat_queue()
	state_machine.transition_to("Attack_Up_Recovery")

