extends PlayerState


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO


func update(delta):
	player.move_and_slide(Vector2.ZERO)
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Basic_Windup")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif not player.last_movement_buttons.empty():
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")

