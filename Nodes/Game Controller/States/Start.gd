extends GameState

var startscreen
var sprite : Sprite

# Called by the state machine upon changing the active state
func enter(_msg := {}):
	startscreen = preload("res://Nodes/GUI/StartScreen.tscn").instance()
	sprite = startscreen.get_child(1)
	sprite.set_position(OS.get_real_window_size() / 2)
	game.add_child(startscreen)

# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	# Center if window size is changed
	sprite.set_position(OS.get_window_size() / 2)
	if Input.is_action_just_pressed("ui_accept"):
		startscreen.animationPlayer.play("Close")
		yield(startscreen, "close_finished")
		state_machine.transition_to("Ingame")
	

# Called by the state machine before changing the active state (clean up)
func exit():
	game.remove_child(startscreen)
	startscreen.queue_free()
	
	
