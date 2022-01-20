extends GameState

onready var ingame = $"../../HUD"

var pausescreen_scene = preload("res://Nodes/GUI/PauseScreen.tscn")
var pausescreen
var sprite : Sprite

# Called by the state machine upon changing the active state
func enter(_msg := {}):
	get_tree().paused = true
	if !pausescreen:
		pausescreen = pausescreen_scene.instance()
		game.add_child(pausescreen)
		pausescreen.connect("resume_game", self, "resume_game")
		
	pausescreen.set_visible(true)
	pausescreen.animationPlayer.play("Open")


# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
#	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
#		pausescreen.animationPlayer.play("Close")
#		yield(pausescreen, "close_finished")
#		state_machine.transition_to("Ingame")
	pass


func resume_game():
	pausescreen.animationPlayer.play("Close")
	yield(pausescreen, "close_finished")
	state_machine.transition_to("Ingame")


# Called by the state machine before changing the active state (clean up)
func exit():
	get_tree().paused = false
	pausescreen.set_visible(false)
