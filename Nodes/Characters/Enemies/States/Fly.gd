extends CharacterState


export var move_accel : float

func _ready():
	processing_mode = 1


func start_animation():
	character.animation.play("Fly")


func physics_update(delta):
	.physics_update(delta)
	
	#Logic
	character.velocity += character.move_input * move_accel * delta
	character.apply_air_drag(delta)
	
	character.move_and_slide(character.velocity, Vector2.ZERO)


func update_animation(delta):
	if not is_equal_approx(character.move_input.x, 0.0):
		if character.is_facing_right && character.move_input.x < 0.0 || !character.is_facing_right && character.move_input.x  > 0.0:
			character.flip()
