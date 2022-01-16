extends GameState

var startscreen

# Called by the state machine upon changing the active state
func enter(_msg := {}):
	startscreen = preload("res://Nodes/GUI/StartScreen.tscn").instance()
	startscreen.get_child(1).set_position(OS.get_real_window_size() / 2)
	print(startscreen.get_child(1).get_position())
	game.add_child(startscreen)

# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		startscreen.animationPlayer.play("Close")
		yield(startscreen, "close_finished")
		state_machine.transition_to("Ingame")
	

# Called by the state machine before changing the active state (clean up)
func exit():
	game.remove_child(startscreen)
	startscreen.queue_free()
	
	
