extends CharacterState

export var walk_move_accel : float
export var run_move_accel : float

func _ready():
	processing_mode = 1
	yield(owner, "ready")
	assert("is_running" in character)


func start_animation():
	character.animation.play("Run")


func physics_update(delta):
	.physics_update(delta)
	#Logic
	if character.is_running:
		character.velocity.x += character.consume_move().x * walk_move_accel * delta
	else:
		character.velocity.x += character.consume_move().x* run_move_accel * delta
	
	character.velocity.y += character.gravity * delta
	character.apply_air_drag(delta)
	
	character.move_and_slide(character.velocity, Vector2.UP)


func update_animation(delta):
	if not is_equal_approx(character.consume_move().x, 0.0):
		if character.is_facing_right && character.move_input.x < 0.0 || !character.is_facing_right && character.move_input.x  > 0.0:
			character.flip()


func check_transitions(delta):
	#Transition Checks
	if !character.is_on_floor():
		state_machine.transition_to("Fall")
