extends EnemyState

# depending on last state (windup or chase) attack chain is possible
var attack_chain : bool
var attack_count : int

func enter(_msg := {}):
	.enter(_msg)
	if state_machine.last_state.name == "Attack_Windup":
		attack_chain = true
		attack_count = 0
	else:
		attack_chain = false
	timer.set_wait_time(enemy.attack_time)
	timer.connect("timeout", self, "_stop_attack")
	timer.start()
	


func physics_update(delta):
	enemy.attack_move(delta,attack_chain)


func _stop_attack():
	state_machine.transition_to("Attack_Recovery")
	

