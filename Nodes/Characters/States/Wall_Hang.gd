extends PlayerState

enum wall_direction {WALL_LEFT, WALL_RIGHT}

var player_gravity_save : int
var wall_direction_save

func enter(_msg := {}):
	.enter(_msg)
	player.velocity.y = player.hang_on_wall_velocity_save
	player_gravity_save = player.gravity
	player.gravity = int(player.wall_hang_acceleration * player.gravity)
	#player.gravity = 0
	
	# Save the position of the wall
	if player.get_slide_collision(0).get_position().x > player.position.x:
		wall_direction_save = wall_direction.WALL_RIGHT
	else:
		wall_direction_save = wall_direction.WALL_LEFT


func physics_update(delta):
	
	# Give the player a horizontal velocity, so that the "stop_with_friction" function
	# in Player deteccts a collision with the wall even if the player doesn't
	# press the move_right/move_left button
	if wall_direction_save == wall_direction.WALL_RIGHT:
		player.velocity.x = (2 * (player.friction_ground + 1))
	else:
		player.velocity.x = -(2 * (player.friction_ground + 1))
	
	player.move(delta)
	
	# If the conditions for a wall hang are not met anymore: transition to antoher state
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
		
	elif Input.is_action_just_pressed("jump") and player.is_on_wall():
		state_machine.transition_to("Wall_Jump")
	elif Input.is_action_pressed("hang_on_wall") and player.is_on_wall():
		if player.velocity.y > player.wall_hang_max_acceleration:
			state_machine.transition_to("Fall")
	else:
		state_machine.transition_to("Fall")


func exit():
	if player.velocity.y > player.wall_hang_max_acceleration:
		player.hang_on_wall_velocity_save = 0.0
		player.can_hang_on_wall = false
	else:
		player.hang_on_wall_velocity_save = player.velocity.y
	player.gravity = player_gravity_save
