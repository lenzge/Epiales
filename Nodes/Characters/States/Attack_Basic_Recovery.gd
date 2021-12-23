extends PlayerState

func enter(_msg := {}):
	animationPlayer.play("Attack_Basic" + str(player.attack_count)+"_Recovery")
	.animation_to_timer()
	
	
func physics_update(delta):
	if player.is_on_floor():
		player.attack_updown_air_move(delta)
	else:
		player._slow_with_friction(player.friction_ground)
		player._fall(delta)
		player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
		
func exit():
	.exit()
	player.attack_count = 1
		
func _on_timeout():
	state_machine.transition_to("Idle")
