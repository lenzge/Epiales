extends PlayerState


var timer : SceneTreeTimer

func enter():
	print("block")
	player.velocity = Vector2.ZERO
	timer = get_tree().create_timer(player.block_time)
	yield(timer, "timeout")
	
	print("timeout")
	state_machine.transition_to("Idle")


func update(delta):
	# Action can't be cancelled
	pass

