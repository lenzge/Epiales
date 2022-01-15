extends PlayerState


func enter(msg :={}):
	.animation_to_timer()


func physics_update(delta):
	# Movement depending on ground or air
	if animationPlayer.current_animation == "Attack_Down_Recovery":
		player.decelerate_move_ground(delta, true)
	else:
		player.fall_straight(delta)
		# Exception for better gameplay
		if Input.is_action_just_pressed("dash") and player.can_dash:
			state_machine.transition_to("Dash")

func _on_timeout():
	# Attention! Otherwise Crocuh_Start animation would be played
	if animationPlayer.current_animation == "Crouch":
		state_machine.transition_to("Crouch")
	else:
		state_machine.transition_to("Fall")
