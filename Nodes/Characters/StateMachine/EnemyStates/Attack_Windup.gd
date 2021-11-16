extends EnemyState

func enter(_msg := {}):
	.enter(_msg)
	timer.set_wait_time(enemy.windup_time)
	timer.start()
	

func physics_update(delta):
	enemy.windup_move(delta)


func _on_timeout():
	pass
	#state_machine.transition_to("Attack")
