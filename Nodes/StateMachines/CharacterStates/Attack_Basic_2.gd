extends PlayerState

var timer :SceneTreeTimer

func enter():
	timer = get_tree().create_timer(player.attack_time)
	yield(timer, "timeout")
	
	# Transition to next state
	var input = player.pop_combat_queue()
	if input == null:
		state_machine.transition_to("Attack_Basic_Recovery")
	elif input == player.PossibleInput.ATTACK_BASIC:
			state_machine.transition_to("Attack_Basic_3")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")


func physics_update(delta):
	player.attack_move(delta)

