extends PlayerState

var force
var direction
var Stimer : SceneTreeTimer

func enter(_msg := {}):
	.enter(_msg)
	force = _msg.force
	direction = _msg.direction
	player.velocity = Vector2.ZERO
	timer.set_wait_time(_msg.time)
	timer.start()
	

func physics_update(delta):
	#player.move(delta)
	player.knockback(delta, force, direction)
	# Action can't be cancelled
	
func _on_timeout():
	state_machine.transition_to("Idle")
	
