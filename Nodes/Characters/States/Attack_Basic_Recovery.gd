extends PlayerState

func enter(_msg := {}):
	animationPlayer.play("Attack_Basic" + str(player.attack_count)+"_Recovery")
	.animation_to_timer()
	
	
func physics_update(delta):
	if player.is_on_floor():
		player.decelerate_move_ground(delta)
	else:
		player.fall_straight(delta)

func exit():
	.exit()
	player.last_input.clear()
	player.attack_count = 1


func _on_timeout():
	state_machine.transition_to("Idle")
