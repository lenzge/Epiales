extends EnemyState

func enter(msg := {}):
	.enter()
	enemy.deal_nightmare = false


func physics_update(delta):
	if enemy.position_cache == null:
		state_machine.transition_to("Patrol")
	elif enemy.global_position.y > enemy.position_cache.y:
		enemy.move_backwards(delta)
	else:
		state_machine.transition_to("Patrol")
