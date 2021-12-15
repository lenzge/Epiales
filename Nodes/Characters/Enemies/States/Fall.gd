 extends CharacterState

func enter(_msg := {}):
	.enter(_msg)
	assert("air_move_speed" in character)
	character.animation.play("Fall")

func physics_update(delta):
	#Logic
	character.velocity.x += character.move_input.x * character.air_move_speed * delta
	character.velocity.y += character.gravity * delta
	character.apply_air_drag(delta)
	
	character.move_and_slide(character.velocity, Vector2.UP)
	
	#Update Animation
	if not is_equal_approx(character.move_input.x, 0.0):
		if character.is_facing_right && character.move_input.x < 0.0 || !character.is_facing_right && character.move_input.x  > 0.0:
			character.flip()
	.physics_update(delta)


func check_transitions(delta):
	#Transition Checks
	if character.is_on_floor():
		state_machine.transition_to("Run")
