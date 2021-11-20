extends EnemyState

func enter(_msg := {}):
	.enter(_msg)
	enemy.velocity = Vector2.ZERO
	timer.set_wait_time(enemy.recovery_time)
	timer.start()
	enemy.is_recovering = true

func physics_update(delta):
	enemy.patrol(delta)
	
	if enemy.attack_windup_detection.is_colliding() and not enemy.is_recovering:
		state_machine.transition_to("Attack_Windup")


# Not for Bird ( hasn't Player detection Area )
func _on_PlayerDetectionArea_body_entered(body):
	if state_machine.state == self and body == enemy.chased_player:
		state_machine.transition_to("Chase")


func _on_timeout():
	enemy.is_recovering = false
