extends EnemyState

func enter(_msg := {}):
	.enter(_msg)
	enemy.velocity = Vector2.ZERO
	

func physics_update(delta):
	enemy.patrol(delta)
	
	if enemy.attack_windup_detection.is_colliding() and not enemy.is_attack_recovering:
		state_machine.transition_to("Attack_Windup")


# Not for Bird ( hasn't Player detection Area )
func _on_PlayerDetectionArea_body_entered(body):
	if state_machine.state == self and body == enemy.chased_player and not enemy.is_chase_recovering:
		enemy.follow_player()
		state_machine.transition_to("Chase_Windup")

func _on_PlayerFollowArea_body_entered(body):
	if state_machine.state == self and body == enemy.chased_player and not enemy.is_chase_recovering:
		enemy.follow_player()
	



