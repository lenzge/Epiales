extends PlayerState

func _ready():
	._ready()
	yield(owner, "ready")


func enter(_msg := {}):
	.enter(_msg)
	timer.set_wait_time(player.windup_time)
	timer.start()


# Check if attack is canceled
func update(delta):
	# Action can be cancelled (not by moving)
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		player._exit_crouch()
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
		player._exit_crouch()
	elif Input.is_action_just_pressed("dash")  and player.can_dash:
		state_machine.transition_to("Dash")
		player._exit_crouch()


func physics_update(delta):
	player.crouch_move(delta)


func _on_timeout():
	var input = player.pop_combat_queue()
	if input == null:
		state_machine.transition_to("Idle")
		player._exit_crouch()
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Crouch_Block_Windup")
	elif input == player.PossibleInput.ATTACK_BASIC:
		state_machine.transition_to("Attack_Down_Ground")
