extends PlayerState


func _ready():
	._ready()
	yield(owner, "ready")


func enter(_msg := {}):
	.enter(_msg)
	
	# Setup wall jump vector if the player was not in wall hang
	if player.wall_jump_vector.length() == 0:
		player.wall_jump_vector.y = -player.jump_impulse
		
		if player.on_wall == player.Walls.RIGHT:
			player.wall_jump_vector.x = -player.wall_jump_speed
		elif player.on_wall == player.Walls.LEFT:
			player.wall_jump_vector.x = player.wall_jump_speed
	
	# set the players velocity
	player.velocity = player.wall_jump_vector
	
	timer.set_wait_time(player.wall_jump_time)
	timer.start()
	
	player.sound_machine.play_sound("Jump", false)


func exit():
	.exit()
	# reset the wall_jump_vector
	player.wall_jump_vector.x = 0
	player.wall_jump_vector.y = 0


func physics_update(delta):
	
	player.move_wall_jump(delta)
	
	if abs(player.velocity.x) < player.speed or player.is_on_wall():
		state_machine.transition_to("Fall")
	elif player.is_on_floor():
		state_machine.transition_to("Run")


func _on_timeout() -> void:
	state_machine.transition_to("Fall")
