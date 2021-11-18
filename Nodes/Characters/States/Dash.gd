extends PlayerState

var timer : Timer


func _ready():
	._ready()
	yield(owner, "ready")
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	timer.set_wait_time(player.dash_time)
	timer.connect("timeout", self, "_stop_dash")
	self.add_child(timer)


func enter(_msg := {}):
	.enter(_msg)
	timer.start()
	player.can_dash = false
	# todo: change player hitbox so player can deal damage while dashing


func exit():
	timer.stop()


func physics_update(delta):
	player.dash_move(delta)


func _stop_dash() -> void:
	if player.last_movement_buttons.empty():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Run")
