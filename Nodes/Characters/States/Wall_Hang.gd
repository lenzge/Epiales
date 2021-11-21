extends PlayerState

var player_gravity_save : int

func enter(_msg := {}):
	.enter(_msg)
	player.velocity.y = player.hang_on_wall_velocity_save
	player_gravity_save = player.gravity
	player.gravity = int(player.wall_hang_acceleration * player.gravity)


func physics_update(delta):
	
	player.move(delta)
	
	if Input.is_action_pressed("hang_on_wall") and player.is_on_wall():
		if player.velocity.y > player.wall_hang_max_acceleration:
			transition_to("Fall")
	else:
		transition_to("Fall")


func transition_to(state: String):
	if player.velocity.y > player.wall_hang_max_acceleration:
		player.hang_on_wall_velocity_save = 0.0
		player.can_hang_on_wall = false
	else:
		player.hang_on_wall_velocity_save = player.velocity.y
	player.gravity = player_gravity_save
	state_machine.transition_to(state)


#	elif player.is_on_wall():
#		if Input.is_action_just_pressed("jump"):
#			if player.get_slide_collision(0).get_position().x > player.position.x:
#				player.velocity.x = -10 * player.speed
#			else:
#				player.velocity.x = 10 * player.speed
#			player.velocity.y = -player.jump_impulse
