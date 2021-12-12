extends PlayerState

enum wall_direction {WALL_LEFT, WALL_RIGHT}

var player_gravity_save : int
var wall_direction_save : int
var player_pos_x_save : float
var player_pos_y_save : float
var checking_for_wall : float = 10.0

func enter(_msg := {}):
	.enter(_msg)
	player.velocity.y = player.hang_on_wall_velocity_save
	
	# Save the position of the wall
	if player.get_slide_collision(0).get_position().x > player.position.x:
		wall_direction_save = wall_direction.WALL_RIGHT
	else:
		wall_direction_save = wall_direction.WALL_LEFT
	
	# Save the position of the player
	player_pos_x_save = player.position.x
	player_pos_y_save = player.position.y
	
	player.sound_machine.play_sound("Slide", true)


func physics_update(delta):
	
	# Only check for a wall (move the player in x-direction) if the player 
	# has moved a bit or wants to jump
	if player.position.y > (player_pos_y_save + checking_for_wall) \
	or Input.is_action_just_pressed("jump"):
		if wall_direction_save == wall_direction.WALL_RIGHT:
			player.velocity.x = 10
		else:
			player.velocity.x = -10
		player_pos_y_save = player.position.y
	
	# Update player position
	player.move_wall_hang(delta)
	
	# If the conditions for a wall hang are not met anymore: transition to another state
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	
	elif is_equal_approx(player_pos_x_save, player.position.x):
		if Input.is_action_just_pressed("jump"):
				state_machine.transition_to("Wall_Jump")
		elif Input.is_action_pressed("hang_on_wall"):
			if player.velocity.y > player.wall_hang_max_gravity:
				state_machine.transition_to("Fall")
	else:
		state_machine.transition_to("Fall")


func exit():
	# Save the current gravitational velocity of the wall hang
	if player.velocity.y > player.wall_hang_max_gravity:
		player.hang_on_wall_velocity_save = 0.0
		player.can_hang_on_wall = false
	else:
		player.hang_on_wall_velocity_save = player.velocity.y
	
	player.sound_machine.stop_sound("Slide")
