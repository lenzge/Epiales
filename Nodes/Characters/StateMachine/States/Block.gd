extends PlayerState


var timer : SceneTreeTimer

func enter():
	player.velocity = Vector2.ZERO
	timer = get_tree().create_timer(player.block_time)
	yield(timer, "timeout")
	
	state_machine.transition_to("Block_Recovery")


func update(delta):
	# Action can't be cancelled
	pass

