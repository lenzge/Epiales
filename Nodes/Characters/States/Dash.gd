extends PlayerState

var timer_dash : Timer
var timer_cooldown :Timer
var after_dash := false
var direction := Vector2()


func _ready():
	._ready()
	yield(owner, "ready")
	_init_timers()


func enter(_msg := {}):
	.enter(_msg)
	timer_dash.start()
	timer_cooldown.stop()
	timer_cooldown.start()
	player.can_dash = false
	player.can_reset_dash = false
	after_dash = false
	direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	direction.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	if !player.is_on_floor():
		player.started_dash_in_air = true
	# todo: change player hitbox so player can deal damage while dashing


func exit():
	timer_dash.stop()


func physics_update(delta):
	if after_dash:
		if player.last_movement_buttons.empty():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	else:
		player.dash_move(delta, direction, after_dash)


func _end_dash_cooldown() -> void:
	timer_cooldown.stop()
	player.can_reset_dash = true


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
	
	timer_cooldown = Timer.new()
	timer_cooldown.set_autostart(false)
	timer_cooldown.set_one_shot(true)
	timer_cooldown.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	timer_cooldown.set_wait_time(player.dash_time + player.dash_cooldown_time)
	timer_cooldown.connect("timeout", self, "_end_dash_cooldown")
	self.add_child(timer_cooldown)
