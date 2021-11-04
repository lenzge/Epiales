extends PlayerState

var timer : Timer
var attack_count : int

func _ready():
	._ready()
	yield(owner, "ready")
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(player.attack_time)
	timer.connect("timeout", self, "_stop_attack")
	self.add_child(timer)


func enter():
	attack_count = 0
	timer.start()


func exit():
	timer.stop()


func physics_update(delta):
	player.attack_move(delta)


func _stop_attack():
	# Transition to next state
	var input = player.pop_combat_queue()
	
	if input == player.PossibleInput.ATTACK_BASIC && attack_count <= player.max_attack_combo:
		timer.start()
		attack_count += 1
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
	else:
		state_machine.transition_to("Attack_Basic_Recovery")
