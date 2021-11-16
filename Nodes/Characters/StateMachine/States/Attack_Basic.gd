extends PlayerState

var attack_count : int

func enter(_msg := {}):
	.enter(_msg)
	attack_count = 1
	timer.set_wait_time(player.attack_time)
	timer.start()


func physics_update(delta):
	player.attack_move(delta)


func _on_timeout():
	# Transition to next state
	var input = player.pop_combat_queue()
	if input == player.PossibleInput.ATTACK_BASIC && attack_count < player.max_attack_combo:
		timer.start()
		attack_count += 1
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
	else:
		state_machine.transition_to("Attack_Basic_Recovery")