class_name PlayerState
extends State

var player : Player
# Timer can be used by every player state. Only need to set_wait_time() and start()
var timer : Timer

onready var animationPlayer : AnimationPlayer = $"../../AnimationPlayer"
onready var particleSystemPlayer : AnimationPlayer = $"../../ParticleSystemPlayer"


# Set Owner as player. Init timer
func _ready():
	yield(owner, "ready")
	player = owner as KinematicBody2D
	assert(player != null)
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.connect("timeout", self, "_on_timeout")
	self.add_child(timer)

# Play corresponding animation. Can be overridden if needed
func enter(_msg := {}):
	animationPlayer.play(self.name)
	animationPlayer.set_speed_scale(1)

# Use, if the state transition should happen after the end of the animation
func animation_to_timer():
	timer.set_wait_time(animationPlayer.current_animation_length)
	timer.start()

# Stop timer automatically on exit
func exit():
	timer.stop()
	
