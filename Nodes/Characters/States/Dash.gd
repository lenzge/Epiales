extends PlayerState

var direction := Vector2()
var jumped := false

func _ready():
	._ready()
	yield(owner, "ready")


func enter(_msg := {}):
	.enter(_msg)
	timer.start(player.dash_time)
	player.can_dash = false
	player.can_reset_dash = false
	player.hitbox.get_child(0).disabled = true
	
	direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	direction.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	if direction.x == 0 and direction.y == 0:
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


func exit():
	.exit()
	jumped = false
	player.hitbox.get_child(0).disabled = false
	player.start_dash_cooldown()


func physics_update(delta):
	
	# if jumping while dash player needs to fall otherwhise space ship mode
	if jumped:
		player.move_leap_jump(delta, direction, player.friction_dash)
		if player.is_on_floor():
			_on_timeout() # get out of dash state. Timer was stopped at jump begin
		return 
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
		jumped = true
		player.velocity.y = -player.jump_impulse
	elif Input.is_action_just_pressed("move_down"):
		state_machine.transition_to("Crouch")


func _on_timeout() -> void:
#	# Keep dashing als long as the player is in the air (busy waiting)
#	while(jumped):
#		if(player.is_on_floor()):
#			break
#		yield(get_tree(), "idle_frame") # wait one frame
	
	if player.last_movement_buttons.empty():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Run")

