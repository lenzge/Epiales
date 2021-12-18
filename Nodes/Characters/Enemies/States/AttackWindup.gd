extends CharacterState

export var move_accel : float
export(int, "GRAVITY", "CONSTANT") var fall_mode : int = 1
export var constant_fall_speed : float = 0
export var should_reset_y_velocity : bool = false

var attack_count : int

func enter(_msg := {}):
	.enter(_msg)
	if should_reset_y_velocity:
		character.velocity.y = 0.0
	if fall_mode == 1:
		character.velocity.y = constant_fall_speed
	attack_count = _msg.attack_count if _msg.has("attack_count") else 0
	character.can_die = false


func physics_update(delta):
	character.velocity.x += move_accel * delta
	if fall_mode == 0:
		character.velocity.y += character.gravity * delta
		character.apply_air_drag(delta)
	else:
		character.apply_air_drag_x(delta)
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func start_animation():
	.start_animation()
	character.animation.play("AttackWindUp"  + str(attack_count))


func _on_timeout():
	state_machine.transition_to("Attack", attack_count)


func exit():
	character.can_die = true
