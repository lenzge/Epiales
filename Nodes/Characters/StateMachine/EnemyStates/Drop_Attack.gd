extends EnemyState

var target_position

func enter(_msg := {}):
	target_position = enemy.chased_player.global_position
	enemy.position_cache = enemy.global_position

func physics_update(delta):
	if not enemy.floor_detection_raycast.is_colliding() and not enemy.attack_detection.is_colliding() and enemy.global_position.y < target_position.y:
		enemy.drop_move(delta, target_position)
	else:
		state_machine.transition_to("Attack")
