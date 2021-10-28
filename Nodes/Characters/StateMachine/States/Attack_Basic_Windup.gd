extends PlayerState

var timer : SceneTreeTimer
var timer_early_exit = false
export var windup_time = 0.3

func enter():
	timer_early_exit = false
	player.velocity = Vector2.ZERO
	timer = get_tree().create_timer(windup_time)
	
	var label := Label.new()
	label.text = "Windup"
	player.add_child(label)
	
	yield(timer, "timeout")
	
	player.remove_child(label)
	label.queue_free()
	
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
