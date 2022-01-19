class_name State, "res://Assets/icons/state_icon.svg"
extends Node 

export(int, "UPDATE", "PHYSICS_UPDATE") var processing_mode : int

var transitions : Array

# Reference to the state machine
var state_machine = null


func _ready():
	for child in get_children():
		if child is Transition:
			transitions.append(child)


# Receives events from the `_unhandled_input()` callback
func handle_input(_event):
	pass


# Corresponds to the `_process()` callback
func update(_delta):
	pass


# Called in '_process()' callback to update animations
func update_animation(delta):
	pass


# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	pass


# Called in '_process()' callback or `_physics_process()` callback depending on processing_mode to check for transitions
func check_transitions(delta) -> void:
	pass


# Called by the state machine upon changing the active state
func enter(_msg := {}):
	pass


# Called by the state machine upon changing the active state to start animations
func start_animation() -> void:
	pass


# Called by the state machine before changing the active state (clean up)
func exit():
	pass

