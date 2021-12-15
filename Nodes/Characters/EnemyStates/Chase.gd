extends EnemyState

var fixed_update_time = 0

func enter(_msg := {}):
	.enter(_msg)
	timer.set_wait_time(enemy.giveup_time)
	timer.start()
	#enemy.follow_player()
	   

func physics_update(delta):
	enemy.chase(delta)
	
	if enemy.attack_detection.is_colliding():
		enemy.set_chase_recover()
		state_machine.transition_to("Attack")
	
	if enemy.is_player_on_other_plattform() or not enemy.is_moving_in_player_direction():
		enemy.set_chase_recover()
		state_machine.transition_to("Patrol")
	

func _on_PlayerDetectionArea_body_exited(body):
	if state_machine.state == self:
		enemy.set_chase_recover()
		state_machine.transition_to("Patrol")

func _on_timeout():
	enemy.set_chase_recover()
	state_machine.transition_to("Patrol")
