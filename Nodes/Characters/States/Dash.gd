extends PlayerState

var _dash_direction := Vector2()
var _jumped := false
onready var charged_hitbox : DamageEmitter = $"../../Charged_Dash"
var charged_timer : Timer


func enter(_msg := {}):
	.enter(_msg)
	player.can_dash = false
	player.can_reset_dash = false
	
	_dash_direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	_dash_direction.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	# Test edge case when crouching dash in direction the player is looking
	
	if player.is_on_floor() and is_equal_approx(_dash_direction.x, 0) and _dash_direction.y > 0:
		# Edge case: Dash while crouching --> still dash foreward
		_dash_direction = Vector2.ZERO
	# Dashing without steering in a _dash_direction
	# or Charged dash <- only possible on ground
	if (_dash_direction.x == 0 and _dash_direction.y == 0 or
		Input.is_action_pressed("charge") and player.is_on_floor() and player.charge_controller.has_charge()):
		if player.sprite.flip_h:
			_dash_direction.x = -1
		else:
			_dash_direction.x = 1
		_dash_direction.y = 0
	_dash_direction = _dash_direction.normalized()
	
	# Charged Dash
	if Input.is_action_pressed("charge") and player.is_on_floor() and player.charge_controller.has_charge():
		player.charge()
		animationPlayer.play("Dash_Charged")
		timer.start(animationPlayer.current_animation_length)
		charged_hitbox.knockback_force = player.charged_dash_damage
		charged_hitbox.emitter_path = player.get_path()
		charged_hitbox.direction = _dash_direction
		# Set Player Speed after initial animaiton
		charged_timer = Timer.new()
		charged_timer.set_one_shot(true)
		charged_timer.connect("timeout", self, "set_velocity")
		add_child(charged_timer)
		charged_timer.start(1.75)
		
		player.sound_machine.play_sound("Charged_Dash", false)
		# todo: deal continous damage instead of damage at the end
		
	# Normal dash
	else:
		timer.start(player.dash_time)
		animationPlayer.play("Dash")
		animationPlayer.set_speed_scale(animationPlayer.current_animation_length/player.dash_time) # Animation takes as long as dash_time
		player.velocity = _dash_direction * player.dash_speed
		player.hitbox.get_child(0).disabled = true
		
		# Tilt in _dash_direction (Attention to crouch and dash)
		if not (_dash_direction.y > 0.5 and player.is_on_floor()):
			player.sprite.set_rotation_degrees(45*_dash_direction.y*player.direction) 
			charged_hitbox.set_rotation_degrees(45*_dash_direction.y*player.direction)
			#player.particles.set_rotation_degrees(45*_dash_direction.y*player.direction)
		
		player.sound_machine.play_sound("Dash", false)
	
	if !player.is_on_floor():
		player.started_dash_in_air = true
	# todo: change player hitbox so player can deal damage while dashing
	#particleSystemPlayer.play("Dash")


## For charged Attack: Set velocity later
func set_velocity():
	player.velocity = _dash_direction * player.dash_speed * 0.8 # Make Charged Dash a little slower but longer


func exit():
	.exit()
	animationPlayer.set_speed_scale(1)
	if player.in_charged_attack:
		player.in_charged_attack = false
		remove_child(charged_timer)
		charged_timer.queue_free()
	_jumped = false
	player.hitbox.get_child(0).disabled = false
	player.start_dash_cooldown()
	player.sprite.set_rotation_degrees(0)
	charged_hitbox.set_rotation_degrees(0)
	#player.particles.set_rotation_degrees(0)


func physics_update(delta):
	
	# if jumping while dash player needs to fall otherwhise space ship mode
	if _jumped:
		player.move_leap_jump(delta, _dash_direction, player.friction_leap_jump)
		if player.is_on_floor():
			_on_timeout() # get out of dash state. Timer was stopped at jump begin
		#return 
	else:
		if is_equal_approx(player.velocity.y, 0):
			# This is needed for player.is_on_floor() to properly work
			player.velocity.y = 0.5 # Todo: Change this to something better
		player.dash_move(delta, _dash_direction, player.friction_dash)
	
	# Check for exit conditions
	if !player.in_charged_attack:
		if Input.is_action_just_pressed("attack"):
			if Input.is_action_pressed("move_up"):
				state_machine.transition_to("Attack_Up_Windup")
			else:
				 state_machine.transition_to("Attack_Basic_Windup")
		elif Input.is_action_just_pressed("block") and player.is_on_floor():
			state_machine.transition_to("Block_Windup")
		if Input.is_action_just_pressed("jump") and not _jumped and player.is_on_floor():
			timer.start(player.leap_jump_time)
			player.hitbox.get_child(0).disabled = false
			_jumped = true
			player.velocity.y = -player.jump_impulse
		elif Input.is_action_just_pressed("move_down"):
			state_machine.transition_to("Crouch")


func _on_timeout() -> void:
	if player.last_movement_buttons.empty():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Run")

