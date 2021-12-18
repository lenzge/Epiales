extends CharacterState

export var dive_speed : float
export var dive_angle : float

func _ready():
	processing_mode = 1


func enter(_msg := {}):
	character.velocity = Vector2.RIGHT.rotated(dive_angle) * dive_speed * (1.0 if character.is_facing_right else 0.0)


func start_animation():
	character.animation.play("Dive")


func physics_update(delta):
	.physics_update(delta)
	character.move_and_collide(character.velocity)


func update_animation(delta):
	if not is_equal_approx(character.move_input.x, 0.0):
		if character.is_facing_right && character.move_input.x < 0.0 || !character.is_facing_right && character.move_input.x  > 0.0:
			character.flip()
