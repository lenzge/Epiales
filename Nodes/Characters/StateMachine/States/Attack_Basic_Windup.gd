extends PlayerState

var timer : SceneTreeTimer
var timer_early_exit = false

func enter():
	timer_early_exit = false
	player.velocity = Vector2.ZERO
	timer = get_tree().create_timer(0.3)
	yield(timer, "timeout")
	
	if timer_early_exit: # if the attack was canceled
		return
	
	state_machine.transition_to("Attack_Basic_1")


func update(delta):
	# For Example if a plattform breaks
	if not player.is_on_floor():
		timer_early_exit = true # cancel attack
		state_machine.transition_to("Fall")
		return

func physics_update(delta):
	player.move(delta)
