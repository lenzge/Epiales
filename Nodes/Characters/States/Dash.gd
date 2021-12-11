extends PlayerState

var after_dash := false
var direction := Vector2()

func _ready():
	._ready()
	yield(owner, "ready")
	_init_timers()


func enter(_msg := {}):
	.enter(_msg)
	timer.start()
	player.can_dash = false
	player.can_reset_dash = false
	after_dash = false
	direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	direction.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	if !player.is_on_floor():
		player.started_dash_in_air = true
	player.sound_machine.play_sound("Dash", false)
	# todo: change player hitbox so player can deal damage while dashing


func physics_update(delta):
	if after_dash:
		if player.last_movement_buttons.empty():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	else:
		player.dash_move(delta, direction, after_dash)


func _on_timeout() -> void:
	after_dash = true
	player.start_dash_cooldown()


func _init_timers() -> void:
	timer.start(player.dash_time)
