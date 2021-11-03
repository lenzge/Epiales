extends PlayerState

var timer : SceneTreeTimer
var timer_early_exit = false

func enter(_msg := {}):
	timer = get_tree().create_timer(player.attack_time)
	yield(timer, "timeout")
	
	if timer_early_exit: # if the attack was canceled
		return
	
	# Transition to next state
	var input = player.pop_combat_queue()
	if input == null:
		state_machine.transition_to("Attack_Basic_Recovery")
	elif input == player.PossibleInput.ATTACK_BASIC:
			state_machine.transition_to("Attack_Basic_2")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")


func physics_update(delta):
	player.attack_move(delta)

func exit():
	timer_early_exit = true
