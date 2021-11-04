class_name PlayerState
extends State

var player : KinematicBody2D

# Owner of the statemachine is a player
func _ready():
	yield(owner, "ready")
	player = owner as KinematicBody2D
	assert(player != null)

