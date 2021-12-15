extends CharacterState

var direction_x : float

func enter(_msg := {}):
	.enter(_msg)
	assert("flinch_time" in character)
	assert("flinch_intensity" in character)
	
	character.can_die = false
	character.velocity = Vector2.ZERO
	direction_x = _msg.direction_x
	
	character.animation.play("Flinch")
	
	timer.start(character.flinch_time)


func update(delta):
	.update(delta)
	character.move_and_slide(Vector2(character.flinch_intensity * direction_x, 0.0), Vector2.UP)
	if character.is_facing_right && direction_x > 0.0 || !character.is_facing_right && direction_x < 0.0:
		character.flip()


func exit():
	.exit()
	character.can_die = true

func _on_timeout():
	state_machine.transition_to("Fall")
