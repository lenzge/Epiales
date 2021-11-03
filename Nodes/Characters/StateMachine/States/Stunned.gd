extends PlayerState

var timer : SceneTreeTimer
var force : int

func enter(_msg := {}):
	force = _msg.force
	player.velocity = Vector2.ZERO
	timer = get_tree().create_timer(_msg.time)
	yield(timer, "timeout")
	
	state_machine.transition_to("Idle")


func update(delta):
	player.knockback(delta, force)
	# Action can't be cancelled
	
