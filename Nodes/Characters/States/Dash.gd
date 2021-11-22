extends PlayerState

var timer_dash : Timer
var timer_windup :Timer
var after_dash := false
var direction := Vector2()


func _ready():
	._ready()
	yield(owner, "ready")
	_init_timers()


func enter(_msg := {}):
	.enter(_msg)
	timer_dash.start()
	timer_windup.start()
	player.can_dash = false
	after_dash = false
	direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	direction.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	# todo: change player hitbox so player can deal damage while dashing


func exit():
	timer_dash.stop()
	timer_windup.stop()


func physics_update(delta):
	player.dash_move(delta, direction, after_dash)


func _end_dash_state() -> void:
	if player.last_movement_buttons.empty():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Run")


func _stop_dash() -> void:
	after_dash = true


func _init_timers() -> void:
	timer_dash = Timer.new()
	timer_dash.set_autostart(false)
	timer_dash.set_one_shot(true)
	timer_dash.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	timer_dash.set_wait_time(player.dash_time)
	timer_dash.connect("timeout", self, "_stop_dash")
	self.add_child(timer_dash)
	
	timer_windup = Timer.new()
	timer_windup.set_autostart(false)
	timer_windup.set_one_shot(true)
	timer_windup.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	timer_windup.set_wait_time(player.dash_time + player.dash_recovery_time)
	timer_windup.connect("timeout", self, "_end_dash_state")
	self.add_child(timer_windup)
