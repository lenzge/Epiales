extends PlayerState

enum wall_direction {WALL_LEFT, WALL_RIGHT}

var wall_direction_save : int

func enter(_msg := {}):
	.enter(_msg)
	player.velocity.y = 0
	
	if player.dash_reset_after_wallhang:
		player.can_dash = true
	
	# Save the position of the wall
	if player.on_wall == player.Walls.RIGHT:
		wall_direction_save = wall_direction.WALL_RIGHT
		var wall_pos_x = player.ray_right.get_collision_point().x - (player.player_size_x / 2)
		player.position.x = wall_pos_x
	elif player.on_wall == player.Walls.LEFT:
		wall_direction_save = wall_direction.WALL_LEFT
		var wall_pos_x = player.ray_left.get_collision_point().x + (player.player_size_x / 2)
		player.position.x = wall_pos_x
	
	player.sound_machine.play_sound("Slide", true)


func physics_update(delta):
	
	# Check if player should still hang on wall (check for wall)
	player.can_change_to_wallhang()
	
	# Update player position
	player.move_wall_hang(delta)
	
	# If the conditions for a wall hang are not met anymore: transition to another state
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	
	else:
		if Input.is_action_just_pressed("jump"):
			
			# The velocity of the wall jump should depend on the player speed of the wall hang
			var l = player.velocity.length()
			var additional_vector_value_y = sqrt(pow(l, 2) * player.wall_jump_additional_y)
			var additional_vector_value_x = sqrt(pow(l, 2) * (1 - player.wall_jump_additional_y))
			
			player.wall_jump_vector.y = -(player.jump_impulse + additional_vector_value_y)
			
			if player.on_wall == player.Walls.RIGHT:
				player.wall_jump_vector.x = -(player.wall_jump_speed + additional_vector_value_x)
			elif player.on_wall == player.Walls.LEFT:
				player.wall_jump_vector.x = (player.wall_jump_speed + additional_vector_value_x)
			
			state_machine.transition_to("Wall_Jump")
		elif Input.is_action_pressed("hang_on_wall"):
			# if there is no wall anymore transition to fall, else stay in wall hang
			if player.on_wall == player.Walls.NONE:
				state_machine.transition_to("Fall")
		else:
			state_machine.transition_to("Fall")


func exit():
	player.sound_machine.stop_sound("Slide")
