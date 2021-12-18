extends Character

func on_hit(emitter : DamageEmitter):
	var direction
	if emitter.direction.is_equal_approx(Vector2.ZERO):
		direction = (hitbox.global_position - emitter.global_position).normalized() 
	else:
		direction = emitter.direction
	state_machine.transition_to("Flinch", {"direction": direction, "force": emitter.knockback_force})
