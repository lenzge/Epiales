extends EnemyState

# depending on last state (windup or chase) attack chain is possible
var attack_chain : bool
var attack_count : int = 0
signal attack_player(attack_cont)

func enter(_msg := {}):
	.enter(_msg)
	if state_machine.last_state.name == "Attack_Windup":
		attack_chain = true
		attack_count = 1
	else:
		attack_count = 0
		attack_chain = false
	timer.set_wait_time(enemy.attack_time)
	timer.start()
	self.connect("attack_player", enemy, "on_attack_player")
	


func physics_update(delta):
	enemy.attack_move(delta,attack_chain)


func _on_timeout():
	attack_count += 1
	if attack_chain and attack_count <= enemy.max_attack_combo:
		timer.start()
	else:
		state_machine.transition_to("Attack_Recovery")
	
	
func _on_AttackArea_body_entered(body):
	print(attack_count)
	emit_signal("attack_player", attack_count)
