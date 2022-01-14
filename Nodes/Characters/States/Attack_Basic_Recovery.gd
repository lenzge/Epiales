extends PlayerState

func enter(_msg := {}):
	animationPlayer.play("Attack_Basic" + str(player.attack_count)+"_Recovery")
	.animation_to_timer()
	
	
func physics_update(delta):
	if player.is_on_floor():
		player.decelerate_move_ground(delta)
	else:
		player.fall_straight(delta)
		# Exception for better gameplay
		if Input.is_action_just_pressed("dash") and player.can_dash:
			state_machine.transition_to("Dash")

func exit():
	.exit()
	player.last_input.clear()
	player.attack_count = 1
	player.attack_direction = 0


func _on_timeout():
	state_machine.transition_to("Idle")
