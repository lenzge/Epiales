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


func enter(_msg := {}):
	.enter(_msg)
	timer.start()


func exit():
	timer.stop()


func physics_update(delta):
	player.attack_move(delta)


func _stop_attack():
	# Transition to next state
	var input = player.pop_combat_queue() # todo: change this --> pops queeu two times in combo (here and in windup)
	
	if input == player.PossibleInput.ATTACK_BASIC && attack_count <= player.max_attack_combo:
		attack_count += 1
		state_machine.transition_to("Attack_Basic_Windup")
	elif input == player.PossibleInput.BLOCK:
		attack_count = 0
		state_machine.transition_to("Block_Windup")
	else:
		attack_count = 0
		state_machine.transition_to("Attack_Basic_Recovery")
