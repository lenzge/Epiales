extends GameState


const PLAYER = preload("res://Nodes/Characters/Player.tscn")
const LEVEL = preload("res://Nodes/Experimental/Maps/Level.tscn")

var player_instance
var level_instance
var player_spawn

# Called by the state machine upon changing the active state
func enter():
	if !level_instance:
		level_instance = LEVEL.instance()
		game.add_child(level_instance)

	if !player_instance:
		player_instance = PLAYER.instance()
		player_spawn = level_instance.get_player_spawn()
		print(player_spawn)
		player_instance.position = player_spawn
		var camera = Camera2D.new()
		camera.current = true			#placeholder, to be determined how to implement
		player_instance.add_child(camera)
		owner.add_child(player_instance)

# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		state_machine.transition_to("Pause")

