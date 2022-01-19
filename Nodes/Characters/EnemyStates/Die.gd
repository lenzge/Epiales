extends EnemyState

func enter(_msg := {}):
	.enter(_msg)
	enemy.deal_nightmare = false
	enemy.velocity = Vector2.ZERO
	timer.set_wait_time(enemy.dying_time)
	timer.start()
	

func physics_update(delta):
	enemy.fall()

func _on_timeout():
	enemy.despawning()

