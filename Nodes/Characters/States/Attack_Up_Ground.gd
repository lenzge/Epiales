extends PlayerState


func enter(msg :={}):
	.enter(msg)
	.animation_to_timer()
	# enable the attack hitboxes
	player.get_node("Attack_Up_Ground/HitboxAttack_Front").disabled = false
	player.get_node("Attack_Up_Ground/HitboxAttack_Top").disabled = false
	
	player.hitbox_up_attack.knockback_force = player.attack_force[0]
	player.hitbox_up_attack.knockback_time = player.attack_knockback[0]
	#player.hitbox_up_attack.is_directed = true
	#player.hitbox_up_attack.direction = Vector2(0, 1)
	
	player.sound_machine.play_sound("Sword Swing " + str(player.sound_machine.get_random(1, 2)), false)


func exit():
	# disable the attack hitboxes
	player.get_node("Attack_Up_Ground/HitboxAttack_Front").disabled = true
	player.get_node("Attack_Up_Ground/HitboxAttack_Top").disabled = true


func _on_timeout():
	var input = player.pop_combat_queue()
	
	if input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
	else:
		state_machine.transition_to("Attack_Up_Ground_Recovery")


func physics_update(delta):
	player.attack_up_ground_move(delta)
