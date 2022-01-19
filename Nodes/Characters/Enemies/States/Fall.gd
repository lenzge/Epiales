extends CharacterState

export var move_accel : float 


func _ready():
	processing_mode = 1


func start_animation():
	character.animation.play("Fall")


func physics_update(delta):
	#Logic
	character.apply_air_drag(delta)
	
	character.velocity.x += character.consume_move().x * move_accel * delta
	character.velocity.y += character.gravity * delta
	
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func update_animation(delta):
	if not is_equal_approx(character.get_move().x, 0.0):
		if character.is_facing_right && character.get_move().x < 0.0 || !character.is_facing_right && character.get_move().x  > 0.0:
			character.flip()
	.physics_update(delta)


func check_transitions(delta):
	#Transition Checks
	if character.is_on_floor():
		state_machine.transition_to("Run")
