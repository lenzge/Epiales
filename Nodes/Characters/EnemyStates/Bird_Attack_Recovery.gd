extends EnemyState


func enter(_msg := {}):
	.enter(_msg)
	timer.set_wait_time(enemy.freeze_time)
	timer.start()
	

func _on_timeout():
	state_machine.transition_to("Repatrol")
