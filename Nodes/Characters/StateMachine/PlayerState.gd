class_name PlayerState
extends State

var player : Player

# Owner of the statemachine is a player
func _ready():
	yield(owner, "ready")
	player = owner as Player
	assert(player != null)

