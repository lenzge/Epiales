extends EnemyState


func enter(_msg := {}):
	.enter(_msg)
	enemy.velocity = Vector2.ZERO
	timer.set_wait_time(enemy.freeze_time)
	timer.start()
	
func update(delta):
	enemy.fall()
	# not stucked in air 
	
func _on_timeout():
	state_machine.transition_to("Patrol")

