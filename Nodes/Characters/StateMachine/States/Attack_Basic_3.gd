extends PlayerState

var timer : SceneTreeTimer
var timer_early_exit = false

func enter(_msg := {}):
	timer = get_tree().create_timer(player.attack_time)
	yield(timer, "timeout")
	
	if timer_early_exit: # if the attack was canceled
		return
		
	state_machine.transition_to("Attack_Basic_Recovery")


func physics_update(delta):
	player.attack_move(delta)


func exit():
	timer_early_exit = true
