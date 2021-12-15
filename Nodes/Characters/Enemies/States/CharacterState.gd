class_name CharacterState
extends State

export(int, "UPDATE", "PHYSICS_UPDATE") var processing_mode

var character : Character
var timer : Timer

# Owner of the statemachine is a enemy
func _ready():
	yield(owner, "ready")
	character = owner
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.connect("timeout", self, "_on_timeout")
	self.add_child(timer)

func update(delta):
	if processing_mode == 0:
		check_transitions(delta)
	.update(delta)

func physics_update(delta):
	if processing_mode == 1:
		check_transitions(delta)
	.physics_update(delta)

func check_transitions(delta) -> void:
	pass

func exit():
	timer.stop()
