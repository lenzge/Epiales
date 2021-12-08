extends EnemyState

func enter(_msg := {}):
	.enter(_msg)
	enemy.velocity = Vector2.ZERO
	

func physics_update(delta):
	enemy.patrol(delta)
	
	if enemy.attack_windup_detection.is_colliding() and not enemy.is_attack_recovering:
		state_machine.transition_to("Attack_Windup")

	if enemy.enemy_detection_raycast.is_colliding():
		if enemy.enemy_detection_raycast.get_collider().direction == enemy.direction:
			state_machine.transition_to("Freeze")
		else:
			enemy.flip_direction()

# Not for Bird ( hasn't Player detection Area )
func _on_PlayerDetectionArea_body_entered(body):
	if enemy.wall_between_raycast.is_colliding():
		if enemy.wall_between_raycast.get_collider().position.x - enemy.global_position.x < body.position.x - enemy.global_position.x:
			print("cant see u")
			return
	if state_machine.state == self and body == enemy.chased_player and not enemy.is_chase_recovering and not enemy.is_player_on_other_plattform():
		enemy.follow_player()
		print("chase")
		state_machine.transition_to("Chase_Windup")

func _on_PlayerFollowArea_body_entered(body):
	if enemy.wall_between_raycast.is_colliding():
		print("find a wall")
		print("abstand zu wand",enemy.wall_between_raycast.get_collider().position.x - enemy.global_position.x)
		print("abstand zum player", body.position.x - enemy.global_position.x)
		if enemy.wall_between_raycast.get_collider().position.x - enemy.global_position.x < body.position.x - enemy.global_position.x:
			print("cant see u")
			return
	if state_machine.state == self and body == enemy.chased_player and not enemy.is_chase_recovering and not enemy.is_player_on_other_plattform():
		print("follow")
		enemy.follow_player()
	



