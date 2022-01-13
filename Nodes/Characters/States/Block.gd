extends PlayerState


func enter(_msg := {}):
	.enter(_msg)
	.animation_to_timer()
	player.velocity = Vector2.ZERO
	
func physics_update(delta):
	player.decelerate_move_ground(delta)

func _on_timeout():
	state_machine.transition_to("Block_Recovery")
