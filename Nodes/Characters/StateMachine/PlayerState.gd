class_name PlayerState
extends State

var player : Player
onready var animationPlayer = $"../../AnimationPlayer"
var timer : SceneTreeTimer
var timer_early_exit = false

# Owner of the statemachine is a player
func _ready():
	yield(owner, "ready")
	player = owner as Player
	assert(player != null)

func _enter(_msg := {}):
	animationPlayer.play(self.name)
	timer_early_exit = false
