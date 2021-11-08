class_name PlayerState
extends State

var player : Player
var timer : Timer
onready var animationPlayer = $"../../AnimationPlayer"

# Owner of the statemachine is a player
func _ready():
	yield(owner, "ready")
	player = owner as Player
	assert(player != null)
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	self.add_child(timer)

func enter(_msg := {}):
	animationPlayer.play(self.name)
	
func exit():
	timer.stop()
