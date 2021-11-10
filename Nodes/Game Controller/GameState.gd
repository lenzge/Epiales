class_name GameState
extends State

var game : Node

# Owner of the statemachine is a player
func _ready():
	yield(owner, "ready")
	game = owner as Node
	assert(game != null)
