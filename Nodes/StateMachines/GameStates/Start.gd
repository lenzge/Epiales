extends GameState

var startscreen

# Called by the state machine upon changing the active state
func enter():
	#placeholder startscreen
	startscreen = Panel.new()
	var message = Label.new()
	message.text = "Press ENTER to start!"
	startscreen.set_size(Vector2(300,50))
	startscreen.add_child(message)
	startscreen.set_position(OS.get_real_window_size() / 2)
	game.add_child(startscreen)

# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("Ingame")

# Called by the state machine before changing the active state (clean up)
func exit():
	game.remove_child(startscreen)
	startscreen.queue_free()
	
	
