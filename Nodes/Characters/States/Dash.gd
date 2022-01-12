extends PlayerState

var direction := Vector2()
var jumped := false


func enter(_msg := {}):
	.enter(_msg)
	timer.start(player.dash_time)
	player.can_dash = false
	player.can_reset_dash = false
	player.hitbox.get_child(0).disabled = true
	
	direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	direction.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	# Test edge case when crouching dash in direction the player is looking
	
	if player.is_on_floor() and is_equal_approx(direction.x, 0) and direction.y > 0:
		# Edge case: Dash while crouching --> still dash foreward
		direction = Vector2.ZERO
	if (direction.x == 0 and direction.y == 0): # Dashing without steering in a direction
		if player.sprite.flip_h:
			direction.x = -1
		else:
			direction.x = 1
	
	direction = direction.normalized()
	player.velocity = direction * player.dash_speed
	
	if !player.is_on_floor():
		player.started_dash_in_air = true
	player.sound_machine.play_sound("Dash", false)
	# todo: change player hitbox so player can deal damage while dashing
	
	
	player.sprite.set_rotation_degrees(45*direction.y*player.direction) 


func exit():
	.exit()
	jumped = false
	player.hitbox.get_child(0).disabled = false
	player.start_dash_cooldown()
	player.sprite.set_rotation_degrees(0)


func physics_update(delta):
	
	# if jumping while dash player needs to fall otherwhise space ship mode
	if jumped:
		player.move_leap_jump(delta, direction, player.friction_leap_jump)
		if player.is_on_floor():
			_on_timeout() # get out of dash state. Timer was stopped at jump begin
		#return 
	else:
		if is_equal_approx(player.velocity.y, 0):
			player.velocity.y = 0.5
		player.dash_move(delta, direction, player.friction_dash)
	
	# Check for exit conditions
	if Input.is_action_just_pressed("attack"):
		timer.stop()
		state_machine.transition_to("Attack_Basic_Windup")
	elif Input.is_action_just_pressed("jump") and not jumped and player.is_on_floor():
		timer.stop()
		timer.start(player.leap_jump_time)
		player.hitbox.get_child(0).disabled = false
		jumped = true
		player.velocity.y = -player.jump_impulse
	elif Input.is_action_just_pressed("move_down"):
		state_machine.transition_to("Crouch")


func _on_timeout() -> void:
	if player.last_movement_buttons.empty():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Run")

