extends EnemyState

func enter(_msg := {}):
	.enter(_msg)
	timer.set_wait_time(enemy.recovery_time)
	timer.start()
	

func physics_update(delta):
	enemy.move_backwards(delta)


func _on_timeout():
	state_machine.transition_to("Patrol")
