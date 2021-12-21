extends PlayerState


func _ready():
	._ready()
	yield(owner, "ready")


func enter(_msg := {}):
	.enter(_msg)
	# Setup player velocities for wall jump
	player.velocity.y = -player.jump_impulse
	if player.get_slide_collision(0).get_position().x > player.position.x:
		player.velocity.x = -player.wall_jump_speed
	else:
		player.velocity.x = player.wall_jump_speed
	
	timer.set_wait_time(player.wall_jump_time)
	timer.start()
	
	player.sound_machine.play_sound("Jump", false)


func physics_update(delta):
	
	player.move_wall_jump(delta)
	
	if abs(player.velocity.x) < player.speed or player.is_on_wall():
		state_machine.transition_to("Fall")
	elif player.is_on_floor():
		state_machine.transition_to("Run")


func _on_timeout() -> void:
	state_machine.transition_to("Fall")
