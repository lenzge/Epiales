class_name PlayerState
extends State

signal transition
var player : Player
var timer : Timer
onready var animationPlayer : AnimationPlayer = $"../../AnimationPlayer"


# Owner of the statemachine is a player
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

	
func enter(_msg := {}):
	animationPlayer.play(self.name)
	animationPlayer.set_speed_scale(1)
	
func animation_to_timer():
	timer.set_wait_time(animationPlayer.current_animation_length)
	timer.start()
	
func exit():
	timer.stop()
	
