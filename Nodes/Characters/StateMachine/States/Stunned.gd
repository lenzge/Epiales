extends PlayerState

var force
var direction
var Stimer : SceneTreeTimer

func enter(_msg := {}):
	.enter(_msg)
	force = _msg.force
	direction = _msg.direction
	player.velocity = Vector2.ZERO
	Stimer = get_tree().create_timer(_msg.time)
	yield(Stimer, "timeout")
	
	state_machine.transition_to("Idle")


func update(delta):
	player.knockback(delta, force, direction)
	# Action can't be cancelled
	
