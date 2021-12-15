extends PlayerState

var force
var direction
var Stimer : SceneTreeTimer

func enter(_msg := {}):
	.enter(_msg)
	force = _msg.force
	direction = _msg.direction
	player.velocity = Vector2.ZERO
	#timer.set_wait_time(_msg.time)
	#timer.start()
	player.set_knockback(force, direction)
	

func physics_update(delta):
	player.move_knockback(delta)
	if player.velocity.x == 0:
		state_machine.transition_to("Idle")
	#player.knockback(delta, force, direction)
	# Action can't be cancelled
	
func _on_timeout():
	state_machine.transition_to("Idle")
	
