extends PlayerState

# If Player is hitted by an enemie he gets a knockback impulse.
# Transition to idle when arriving standstill on x-axis. Can't be cancelled on other ways.


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	player.set_knockback(_msg.force, _msg.direction)
	# Reset
	player.attack_direction = 0
	

func physics_update(delta):
	player.move_knockback(delta)
	# Only escape condition
	if player.velocity.x == 0:
		state_machine.transition_to("Idle")
	

