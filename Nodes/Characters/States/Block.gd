extends PlayerState

# Block after Windup. Can't be cancelled. Only available on ground

func enter(_msg := {}):
	.enter(_msg)
	.animation_to_timer()
	player.sound_machine.play_sound("Blocking Stance", false)

func physics_update(delta):
	# For smooth deceleration after moving
	player.decelerate_move_ground(delta)

func _on_timeout():
	state_machine.transition_to("Block_Recovery")
 
func _on_blocked():
	particleSystemPlayer.play("Block")
