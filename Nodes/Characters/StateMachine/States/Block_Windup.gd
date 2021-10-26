extends PlayerState

var timer : SceneTreeTimer
var timer_early_exit = false

func enter():
	print("windup")
	player.velocity = Vector2.ZERO
	timer_early_exit = false
	timer = get_tree().create_timer(player.windup_time)
	yield(timer, "timeout")
	
	if timer_early_exit: # if the attack was canceled
		return
	print("timeout")
	state_machine.transition_to("Block")


func update(delta):
	# Action can be cancelled (not by moving)
	
	if not player.is_on_floor():
		timer_early_exit = true
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		timer_early_exit = true
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("basic_attack"):
		timer_early_exit = true
		state_machine.transition_to("Attack_Begin")


