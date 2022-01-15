extends CharacterState

export var walk_move_accel : float
export var run_move_accel : float

func _ready():
	processing_mode = 1
	yield(owner, "ready")


func start_animation():
	character.animation.play("Idle")


func physics_update(delta):
	.physics_update(delta)
	
	character.apply_air_drag(delta)
	
	#Logic
	if character.is_running:
		character.velocity.x += character.consume_move().x * run_move_accel * delta
	else:
		character.velocity.x += character.consume_move().x * walk_move_accel * delta
	
	character.velocity.y += character.gravity * delta
	
	
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func update_animation(delta):
	if not is_equal_approx(character.get_move().x, 0.0):
		if character.is_running:
			if character.animation.current_animation != "Run":
				character.animation.play("Run")
		else:
			if character.animation.current_animation != "Walk":
				character.animation.play("Walk")
		if character.is_facing_right && character.get_move().x < 0.0 || !character.is_facing_right && character.get_move().x  > 0.0:
			character.flip()
	else:
		if character.animation.current_animation != "Idle":
			character.animation.play("Idle")


func check_transitions(delta):
	#Transition Checks
	if !character.is_on_floor():
		state_machine.transition_to("Fall")
	if "is_focused" in character and character.is_focused:
		state_machine.transition_to("FocusedRun")
