class_name Ingame
extends GameState


const PLAYER = preload("res://Nodes/Characters/Player.tscn")
const LEVEL = preload("res://Nodes/Experimental/Maps/Level.tscn")
const NIGHTMARE_BAR = preload("res://Nodes/GUI/NightmareBar.tscn")

var player_instance 
var level_instance
var nightmare_instance
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
	
	if !nightmare_instance:
		nightmare_instance = NIGHTMARE_BAR.instance()
		nightmare_instance.init(player_instance)
		game.get_node("HUD").add_child(nightmare_instance)

# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		player_instance.last_movement_buttons.clear()
		state_machine.transition_to("Pause")

