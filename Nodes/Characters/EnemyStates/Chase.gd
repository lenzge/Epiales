extends EnemyState

var fixed_update_time = 0

func enter(_msg := {}):
	.enter(_msg)
	timer.set_wait_time(enemy.giveup_time)
	timer.start()
	#enemy.follow_player()
	   

func physics_update(delta):
	enemy.chase(delta)
	
	if enemy.attack_detection.is_colliding() or not enemy.moving_in_player_direction() or enemy.is_player_on_other_plattform():
		enemy.set_chase_recover()
		state_machine.transition_to("Attack")
	
	# No instant turn
	#fixed_update_time += delta
	#if(fixed_update_time > 1):
		#fixed_update_time = 0
		#enemy.follow_player()

func _on_PlayerDetectionArea_body_exited(body):
	if state_machine.state == self:
		enemy.set_chase_recover()
		state_machine.transition_to("Patrol")

func _on_timeout():
	enemy.set_chase_recover()
	state_machine.transition_to("Patrol")
