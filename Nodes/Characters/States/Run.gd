extends PlayerState

# Player is in run state, when he is only moving on floor

# When start running, there is another Animation then while running (Run_loop)
var is_running : bool

# Always start with the walk animation for smoother transition, except at transition
# from Crouch/slide to Run
func enter(msg := {}):
	if state_machine.last_state.name == "Crouch":
		animationPlayer.play("Crouch_Run")
		is_running = true
	else:
		animationPlayer.play("Walk")
		is_running = false
	player.sound_machine.play_sound("Running", true)
	

func exit():
	player.sound_machine.stop_sound("Running")

# Movement and checking for escape conditions
func physics_update(delta):
		
		
	# Checking which animation in which speed is playing, depending on the players speed
	if abs(player.velocity.x) > 200:
		animationPlayer.set_speed_scale(animationPlayer.run_speed_fast)
	elif abs(player.velocity.x) > 100:
		animationPlayer.set_speed_scale(animationPlayer.run_speed_slow)
	# Attention to edge case when running against a wall! speed < 100 but Run animation
	elif not animationPlayer.current_animation == "Crouch_Run" and not animationPlayer.current_animation == "Run_Turn" and not player.is_on_wall():
		animationPlayer.set_speed_scale(animationPlayer.walk_speed)
		is_running = false
		animationPlayer.play("Walk")
	# Animation transition from Walk to Run
	if not is_running and abs(player.velocity.x) > 100:
		is_running = true
		animationPlayer.play("Run")
	# Actual movement
	player.move(delta)
	
	
	# Checking for running turn around
	if not player.direction == player.prev_direction and abs(player.velocity.x) > 90:
		is_running = true
		animationPlayer.play("Run_Turn")
		
		
	# Play varying running sound
	player.sound_machine.randomize_level("Running", -6.0, 3.0)
	player.sound_machine.randomize_pitch("Running", 0.7, 1.5)
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("move_up"):
			state_machine.transition_to("Attack_Up_Windup")
		else:
			state_machine.transition_to("Attack_Basic_Windup")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")
	elif player.last_movement_buttons.empty():
		player.last_movement_buttons.clear()
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
	elif Input.is_action_pressed("move_down"):
		state_machine.transition_to("Crouch")
		
