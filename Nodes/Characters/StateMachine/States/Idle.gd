extends PlayerState


func enter():
	player.velocity = Vector2.ZERO
	print("idle")


func update(delta):
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")

