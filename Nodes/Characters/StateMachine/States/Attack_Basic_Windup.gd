extends PlayerState

var timer : SceneTreeTimer
var timer_early_exit = false

func enter():
	timer_early_exit = false
	player.velocity = Vector2.ZERO
	timer = get_tree().create_timer(player.windup_time)
	
	yield(timer, "timeout")
	
	
	if timer_early_exit: # if the attack was canceled
		return
	
	state_machine.transition_to("Attack_Basic_1")


func update(delta):
	# Action can be cancelled (not by moving)
	
	if not player.is_on_floor():
		timer_early_exit = true
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		timer_early_exit = true
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("block"):
		timer_early_exit = true
		state_machine.transition_to("Block_Windup")

func physics_update(delta):
	player.move(delta)
