extends PlayerState

var Stimer : SceneTreeTimer
var timer_early_exit : bool

func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	Stimer = get_tree().create_timer(player.block_time)
	yield(Stimer, "timeout")
	
	if timer_early_exit: # if the attack was canceled
		return
	
	state_machine.transition_to("Block_Recovery")


func update(delta):
	# Action can't be cancelled
	pass
