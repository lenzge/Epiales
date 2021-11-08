extends EnemyState

func enter(_msg := {}):
	.enter(_msg)

func physics_update(delta):
	enemy.chase(delta)

func _on_PlayerDetectionArea_body_exited(body):
	if state_machine.state == self:
		state_machine.transition_to("Patrol")

func _on_AttackDetectionArea_body_entered(body):
	state_machine.transition_to("Attack")
