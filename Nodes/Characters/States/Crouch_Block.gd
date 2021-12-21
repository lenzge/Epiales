extends PlayerState

func enter(_msg := {}):
	.enter(_msg)
	.animation_to_timer()
	player.velocity = Vector2.ZERO


func physics_update(delta):
	player.crouch_move(delta)


func _on_timeout():
	state_machine.transition_to("Crouch_Block_Recovery")
