extends CharacterState

export(int, "GRAVITY", "CONSTANT") var fall_mode : int = 1
export var constant_fall_speed : float = 0
export var should_reset_y_velocity : bool = false

func enter(_msg := {}):
	.enter(_msg)
	character.velocity.x = 0.0
	if should_reset_y_velocity:
		character.velocity.y = 0.0
	if fall_mode == 1:
		character.velocity.y = constant_fall_speed


func physics_update(delta):
	.physics_update(delta)
	if fall_mode == 0:
		character.velocity.y += character.gravity * delta
		character.apply_air_drag(delta)
	else:
		character.apply_air_drag_x(delta)
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func start_animation():
	.start_animation()
	character.animation.play("Recoil") 


func _on_timeout():
	state_machine.transition_to("Run")
