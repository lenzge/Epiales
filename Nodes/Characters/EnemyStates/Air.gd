extends EnemyState

func physics_update(delta):
	enemy.move(delta)
	
	if enemy.is_on_floor():
		state_machine.transition_to("Patrol")

