class_name EnemyState
extends State

var enemy : Puppet
var timer : Timer
onready var animationPlayer = $"../../AnimationPlayer"

# Owner of the statemachine is a enemy
func _ready():
	yield(owner, "ready")
	enemy = owner as Puppet
	assert(enemy != null)
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.connect("timeout", self, "_on_timeout")
	self.add_child(timer)

func enter(_msg := {}):
	animationPlayer.play(self.name)

func exit():
	timer.stop()
