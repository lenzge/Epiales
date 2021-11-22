extends PlayerState

var timer : Timer
var cooldown_timer : Timer

func _ready():
	._ready()
	yield(owner, "ready")
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(player.windup_time)
	timer.connect("timeout", self, "_stop_attack_windup")
	self.add_child(timer)
	cooldown_timer = Timer.new()
	cooldown_timer.set_autostart(false)
	cooldown_timer.set_one_shot(true)
	cooldown_timer.set_timer_process_mode(0)
	cooldown_timer.set_wait_time(player.attack_cooldown_time)
	self.add_child(cooldown_timer)

func enter(_msg := {}):
	.enter(_msg)
	
	timer.start()


func exit():
	timer.stop()


# Check if attack is canceled
func update(delta):
	# Action can be cancelled (not by moving)
	if cooldown_timer.time_left > 0:
		state_machine.transition_to("Idle")
	elif not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("block"):
		state_machine.transition_to("Block_Windup")
	elif Input.is_action_just_pressed("dash")  and player.can_dash:
		state_machine.transition_to("Dash")


func physics_update(delta):
	player.move(delta)


func _stop_attack_windup():
	print("[DEBUG] - Breakpoint")
	var input = player.pop_combat_queue()
	cooldown_timer.start()
	if input == null:
		state_machine.transition_to("Idle")
	elif input == player.PossibleInput.ATTACK_BASIC:
		state_machine.transition_to("Attack_Basic")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
