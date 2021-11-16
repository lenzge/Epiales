extends PlayerState

var force : int
var timer : SceneTreeTimer

func enter(_msg := {}):
	.enter(_msg)
	force = _msg.force
	player._knockback(force)
	timer = get_tree().create_timer(_msg.time)
	yield(timer, "timeout")
	
	state_machine.transition_to("Idle")


func physics_update(delta):
	player.move(delta)
	# Action can't be cancelled
	
