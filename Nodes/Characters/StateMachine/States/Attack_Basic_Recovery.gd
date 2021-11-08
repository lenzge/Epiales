extends PlayerState


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	timer.set_wait_time(player.attack_time)
	timer.connect("timeout", self, "_stop_attack_recovery")
	timer.start()




func _stop_attack_recovery():
	state_machine.transition_to("Idle")
