extends EnemyState


func enter(_msg := {}):
	if state_machine.last_state.name == "Attack":
		.enter(_msg)
	else:
		animationPlayer.play("Freeze")
	timer.set_wait_time(enemy.freeze_time)
	timer.start()
	

func _on_timeout():
	enemy.set_attack_recover()
	state_machine.transition_to("Repatrol")
