extends PlayerState

var timer : Timer

func _ready():
	._ready()
	yield(owner, "ready")
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(player.attack_time)
	timer.connect("timeout", self, "_stop_block_recovery")
	self.add_child(timer)


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	timer.start()


func exit():
	timer.stop()


func update(delta):
	# Action can be cancelled (not by moving)
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		player._exit_crouch()
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
		player._exit_crouch()
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Ground_Windup")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
		player._exit_crouch()


func physics_update(delta):
	player.crouch_move(delta)


func _stop_block_recovery():
	player.pop_combat_queue()
	state_machine.transition_to("Crouch_Block")
