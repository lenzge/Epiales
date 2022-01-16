extends GameState

var pausescreen
onready var ingame = $"../../HUD"

# Called by the state machine upon changing the active state
func enter(_msg := {}):
	get_tree().paused = true
	if !pausescreen:
		pausescreen = preload("res://Nodes/GUI/PauseScreen.tscn").instance()
		pausescreen.get_child(1).set_position(OS.get_window_size() / 2)
		game.add_child(pausescreen)

	else:
		pausescreen.visible = true
		pausescreen.animationPlayer.play("Idle")


# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		pausescreen.animationPlayer.play("Close")
		yield(pausescreen, "close_finished")
		state_machine.transition_to("Ingame")

# Called by the state machine before changing the active state (clean up)
func exit():
	get_tree().paused = false
	pausescreen.visible = false
