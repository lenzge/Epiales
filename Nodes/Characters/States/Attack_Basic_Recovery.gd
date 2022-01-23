extends PlayerState

# Recovery phase after attacking/ end of attack chain. In air and on ground
# Can't be cancelled (except by getting damage and dashing in air)

func enter(_msg := {}):
	
	if player.in_air_attack:
		animationPlayer.play("Attack_Basic" + str(player.attack_count)+"_Recovery_Air")
	else:
		animationPlayer.play("Attack_Basic" + str(player.attack_count)+"_Recovery")
	
	.animation_to_timer()


func physics_update(delta):
	# Movement depending on air or ground
	if player.is_on_floor():
		player.decelerate_move_ground(delta)
	else:
		player.fall_straight(delta)
		# Exception for better gameplay
		if Input.is_action_just_pressed("dash") and player.can_dash:
			state_machine.transition_to("Dash")

	# Can fall in ground attack
	if not player.in_air_attack and not player.is_on_floor() and not player.in_charged_attack:
		state_machine.transition_to("Fall")

# Reset
func exit():
	.exit()
	player.last_input.clear()
	player.attack_count = 1
	player.attack_direction = 0
	player.in_air_attack = false


func _on_timeout():
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Fall")
