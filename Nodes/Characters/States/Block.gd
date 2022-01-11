extends PlayerState


func enter(_msg := {}):
	.enter(_msg)
	.animation_to_timer()
	player.velocity = Vector2.ZERO
	
func update(delta):
	# Action can't be cancelled
	pass

func _on_timeout():
	state_machine.transition_to("Block_Recovery")
