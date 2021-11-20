extends GameState

var pausescreen
onready var ingame = $"../../HUD"

# Called by the state machine upon changing the active state
func enter(_msg := {}):
	get_tree().paused = true
	if !pausescreen:
		#placeholder pausescreen
		pausescreen = Panel.new()
		var message = Label.new()
		message.text = "Press ESC to resume!"
		message.set_align(Label.ALIGN_CENTER)
		message.set_valign(Label.ALIGN_CENTER)
		pausescreen.set_size(Vector2(300,50))
		pausescreen.add_child(message)
		pausescreen.set_position(OS.get_real_window_size() / 2)
		ingame.add_child(pausescreen)
	else:
		pausescreen.visible = true

# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		state_machine.transition_to("Ingame")

# Called by the state machine before changing the active state (clean up)
func exit():
	get_tree().paused = false
	pausescreen.visible = false
