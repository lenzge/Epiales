extends PlayerState

func enter(msg :={}):
	.enter(msg)
	player._enter_crouch()


func update(delta):
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		player._exit_crouch()
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Ground_Windup")
	elif !Input.is_action_pressed("move_down"):
		state_machine.transition_to("Idle")
		player._exit_crouch()
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
		player._exit_crouch()
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		player._exit_crouch()


func physics_update(delta):
	player.crouch_move(delta)
