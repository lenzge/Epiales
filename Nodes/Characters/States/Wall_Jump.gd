extends PlayerState

var timer : Timer


func _ready():
	._ready()
	yield(owner, "ready")
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	timer.set_wait_time(player.wall_jump_time)
	timer.connect("timeout", self, "_return_control")
	self.add_child(timer)


func enter(_msg := {}):
	.enter(_msg)
	# Setup player velocities for wall jump
	player.velocity.y = -player.jump_impulse
	if player.get_slide_collision(0).get_position().x > player.position.x:
		player.velocity.x = -player.wall_jump_speed
	else:
		player.velocity.x = player.wall_jump_speed
	
	timer.start()


func physics_update(delta):
	
	player.move_wall_jump(delta)
	
	if abs(player.velocity.x) < player.speed or player.is_on_wall():
		state_machine.transition_to("Fall")
	elif player.is_on_floor():
		state_machine.transition_to("Run")


func exit():
	timer.stop()


func _return_control() -> void:
	state_machine.transition_to("Fall")
