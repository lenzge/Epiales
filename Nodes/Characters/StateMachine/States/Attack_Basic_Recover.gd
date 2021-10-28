extends PlayerState

var timer : SceneTreeTimer
export var recovery_time = 0.5

func enter():
	player.velocity = Vector2.ZERO
	
	var label := Label.new()
	label.text = "Recovery"
	player.add_child(label)
	
	timer = get_tree().create_timer(recovery_time)
	yield(timer, "timeout")
	
	player.remove_child(label)
	label.queue_free()
	
	state_machine.transition_to("Idle")
