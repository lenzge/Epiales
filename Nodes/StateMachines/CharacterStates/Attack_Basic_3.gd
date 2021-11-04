extends PlayerState

var timer : SceneTreeTimer

func enter():
	timer = get_tree().create_timer(player.attack_time)
	yield(timer, "timeout")
	
	state_machine.transition_to("Attack_Basic_Recovery")


func physics_update(delta):
	player.attack_move(delta)

