extends PlayerState

func enter(_msg := {}):
	.enter(_msg)
	timer.set_wait_time(player.recovery_time)
	timer.start()


func physics_update(delta):
	if player.is_on_floor():
		player.attack_updown_air_move(delta)
	else:
		player._slow_with_friction(player.friction_ground)
		player._fall(delta)
		player.velocity = player.move_and_slide(player.velocity, Vector2.UP)


func _on_timeout():
	state_machine.transition_to("Idle")
