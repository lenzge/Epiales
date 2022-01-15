extends CharacterState

export(int, "GRAVITY", "CONSTANT") var fall_mode : int = 1
export var constant_fall_speed : float = 0
export var should_reset_y_velocity : bool = false


func _ready():
	processing_mode = 1


func enter(_msg := {}):
	.enter(_msg)
	character.velocity.x = 0.0
	if should_reset_y_velocity:
		character.velocity.y = 0.0
	if fall_mode == 1:
		character.velocity.y = constant_fall_speed


func physics_update(_delta):
	.physics_update(_delta)
	if fall_mode == 0:
		character.velocity.y += character.gravity * _delta
		character.apply_air_drag(_delta)
	else:
		character.apply_air_drag_on_x(_delta)
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func start_animation():
	.start_animation()
	character.animation.play("Recoil") 


func _on_timeout():
	state_machine.transition_to("Run")
