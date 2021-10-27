extends PlayerState

func enter():
	player.velocity = Vector2.ZERO
	player.attack()
	


func update(delta):
	# For Example if a plattform breaks
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return



func _on_AnimationPlayer_animation_finished(anim_name):
	if is_equal_approx(player.get_direction(), 0.0):
		state_machine.transition_to("Idle")
	elif player.is_on_floor():
		state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Fall")
