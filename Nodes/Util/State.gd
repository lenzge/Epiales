class_name State
extends Node


# Reference to the state machine
var state_machine = null


# Receives events from the `_unhandled_input()` callback
func handle_input(_event):
	pass


# Corresponds to the `_process()` callback
func update(_delta):
	pass


# Corresponds to the `_physics_process()` callback
func physics_update(_delta):
	pass


# Called by the state machine upon changing the active state
func enter(_msg := {}):
	pass


# Called by the state machine before changing the active state (clean up)
func exit():
	pass

