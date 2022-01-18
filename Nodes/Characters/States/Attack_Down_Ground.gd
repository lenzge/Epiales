extends PlayerState

# In air and on ground, depending on where the windup started.
# Known by the current animation

func enter(msg :={}):
	# Animation set in animationController, depending on last animation
	.animation_to_timer()
	# Enable the attack hitboxes
	if animationPlayer.current_animation == "Attack_Down":
		player.get_node("Attack_Down_Ground/HitboxAttack").disabled = false
		#TODO: knockback_force should be 0, but then the enemy gets no damage...
		player.hitbox_up_attack.damage_amount = player.attack_force_down
		player.hitbox_down_attack.knockback_force = player.attack_force_down
		player.hitbox_down_attack.knockback_time = player.attack_knockback[0]
	else:
		player.get_node("Attack_Down_Air/HitboxAttack").disabled = false
		player.hitbox_up_attack.damage_amount = player.attack_force_down
		player.hitbox_down_attack_air.knockback_force = player.attack_force_down
		player.hitbox_down_attack_air.knockback_time = player.attack_knockback[0]
	
	player.sound_machine.play_sound("Sword Swing " + str(player.sound_machine.get_random(1, 2)), false)
	player.sound_machine.play_sound("Attack Grunt " + str(player.sound_machine.get_random(1, 8)), false)


func physics_update(delta):
	# Movement depending on ground or air
	if animationPlayer.current_animation == "Attack_Down":
		player.decelerate_move_ground(delta, true)
	else:
		player.air_attack_move(delta)


# Disable the attack hitboxes
func exit():
	.exit()
	player.get_node("Attack_Down_Ground/HitboxAttack").disabled = true
	player.get_node("Attack_Down_Air/HitboxAttack").disabled = true


func _on_timeout():
	var input = player.pop_combat_queue()
	state_machine.transition_to("Attack_Down_Recovery")

