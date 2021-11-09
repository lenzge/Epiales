extends EnemyState

func enter(_msg := {}):
	.enter(_msg)
	enemy.velocity = Vector2.ZERO

func physics_update(delta):
	enemy.patrol(delta)


func _on_PlayerDetectionArea_body_entered(body):
	if state_machine.state == self and body == enemy.chased_player:
		state_machine.transition_to("Chase")


func _on_AttackWindupDetectionArea_body_entered(body):
	if state_machine.state == self and body == enemy.chased_player:
		state_machine.transition_to("Attack_Windup")
