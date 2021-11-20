extends PlayerState


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	timer.set_wait_time(player.attack_time)
	timer.start()




func _on_timeout():
	state_machine.transition_to("Idle")
