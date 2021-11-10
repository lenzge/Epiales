extends EnemyState

var fixed_update_time = 0

func enter(_msg := {}):
	.enter(_msg)
	enemy.find_player()
	   

func physics_update(delta):
	enemy.chase(delta)
	
	# No instant turn
	fixed_update_time += delta
	if(fixed_update_time > 1):
		fixed_update_time = 0
		enemy.find_player()

func _on_PlayerDetectionArea_body_exited(body):
	if state_machine.state == self:
		state_machine.transition_to("Patrol")

func _on_AttackDetectionArea_body_entered(body):
	if state_machine.state == self:
		state_machine.transition_to("Attack")
