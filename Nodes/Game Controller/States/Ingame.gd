class_name Ingame
extends GameState


const PLAYER = preload("res://Nodes/Characters/Player/Player.tscn")
const LEVEL = preload("res://Nodes/Experimental/Maps/Level.tscn")

var player_instance 
var level_instance
var player_spawn : Position2D

# Called by the state machine upon changing the active state
func enter(_msg := {}):
	if !level_instance:
		level_instance = LEVEL.instance()
		game.add_child(level_instance)
		
	if !player_instance:
		player_instance = PLAYER.instance()
		player_instance.set_owner(level_instance)
		level_instance.spawn_player(player_instance)

# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		player_instance.last_movement_buttons.clear()
		state_machine.transition_to("Pause")

