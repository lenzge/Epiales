extends CharacterState

export var walk_move_accel : float
export var run_move_accel : float
export var backwards_factor : float

func _ready():
	processing_mode = 1
	yield(owner, "ready")
	assert("is_running" in character)
	assert("is_focused" in character)

func physics_update(_delta):
	.physics_update(_delta)
	
	var is_moving_backwards = character.is_facing_right && character.get_move().x < 0.0 || !character.is_facing_right && character.get_move().x  > 0.0
	
	character.apply_air_drag(_delta)
	
	#Logic
	if character.is_running:
		if is_moving_backwards:
			character.velocity.x += character.consume_move().x * run_move_accel * backwards_factor * _delta
		else:
			character.velocity.x += character.consume_move().x * run_move_accel * _delta
	else:
		if is_moving_backwards:
			character.velocity.x += character.consume_move().x * walk_move_accel  * backwards_factor * _delta
		else:
			character.velocity.x += character.consume_move().x * walk_move_accel  * _delta
	
	character.velocity.y += character.gravity * _delta
	
	
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func update_animation(delta):
	if not is_equal_approx(character.get_move().x, 0.0):
		if character.is_running:
			if character.is_facing_right && character.get_move().x < 0.0 || !character.is_facing_right && character.get_move().x  > 0.0:
				if character.animation.current_animation != "FocusedRunBackwards":
					character.animation.play("FocusedRunBackwards")
			else:
				if character.animation.current_animation != "FocusedRunForwards":
					character.animation.play("FocusedRunForwards")
		else:
			if character.is_facing_right && character.get_move().x < 0.0 || !character.is_facing_right && character.get_move().x  > 0.0:
				if character.animation.current_animation != "FocusedWalkBackwards":
					character.animation.play("FocusedWalkBackwards")
			else:
				if character.animation.current_animation != "FocusedWalkForwards":
					character.animation.play("FocusedWalkForwards")
	else:
		if character.animation.current_animation != "FocusedIdle":
			character.animation.play("FocusedIdle")


func check_transitions(delta):
	#Transition Checks
	if !character.is_on_floor():
		state_machine.transition_to("Fall")
	if not character.is_focused:
		state_machine.transition_to("Run")
