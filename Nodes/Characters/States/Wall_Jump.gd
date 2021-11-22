extends PlayerState

#TODOs:
# - fix bug when player holds shift and jumps from floor
# - is a player.move_wall_jump() function possible?

func enter(_msg := {}):
	.enter(_msg)
	# Setup player velocities for wall jump
	player.velocity.y = -player.jump_impulse
	if player.get_slide_collision(0).get_position().x > player.position.x:
		player.velocity.x = -player.wall_jump_power * player.speed
	else:
		player.velocity.x = player.wall_jump_power * player.speed


func physics_update(delta):
	state_machine.transition_to("Jump")
