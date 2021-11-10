extends GameState


const PLAYER = preload("res://Nodes/Characters/Player.tscn")
const LEVEL = preload("res://Nodes/Experimental/Maps/Level.tscn")

var player_instance : Player
var level_instance : Level
var player_spawn : Position2D

# Called by the state machine upon changing the active state
func enter(_msg := {}):
	if !level_instance:
		level_instance = LEVEL.instance()
		game.add_child(level_instance)
	
	
	
	if !player_instance:
		player_instance = PLAYER.instance()
		level_instance.spawn_player(player_instance)

# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		state_machine.transition_to("Pause")

