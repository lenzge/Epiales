extends EnemyState

func physics_update(delta):
	if not enemy.floor_detection_raycast.is_colliding():
		enemy.drop_move(delta)
	else:
		state_machine.transition_to("Attack")
