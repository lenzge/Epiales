extends PlayerState


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	timer.set_wait_time(player.block_time)
	timer.start()
	
func update(delta):
	# Action can't be cancelled
	pass

func _on_timeout():
	state_machine.transition_to("Block_Recovery")
