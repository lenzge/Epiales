extends EnemyState

func physics_update(delta):
	if enemy.global_position.y > enemy.position_cache.y:
		enemy.move_backwards(delta)
	else:
		state_machine.transition_to("Patrol")
