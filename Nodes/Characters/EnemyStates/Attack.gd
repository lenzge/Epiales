extends EnemyState

# depending on last state (windup or chase) attack chain is possible
var attack_chain : bool
var is_blocked : bool
var is_hit : bool

func enter(_msg := {}):
	.enter(_msg)
	is_blocked = false
	is_hit = false
	# Puppet in attack chain
	if state_machine.last_state.name == "Attack_Windup":
		attack_chain = true
		enemy.attack_count += 1
	else:
		enemy.attack_count = 0
		attack_chain = false
	timer.set_wait_time(enemy.attack_time)
	timer.start()
	enemy.attack_area.knockback_force = enemy.attack_force[enemy.attack_count]



func physics_update(delta):
	enemy.attack_move(delta,attack_chain)


func _on_timeout():
	print(enemy.attack_count)
	if attack_chain and not is_blocked and is_hit and enemy.attack_count < enemy.max_attack_combo:
		is_hit = false
		state_machine.transition_to("Attack_Windup")
	else:
		if state_machine.last_state.name == "Attack_Windup":
			enemy.set_attack_recover()
			enemy.attack_count = 0
		state_machine.transition_to("Attack_Recovery")


func on_attack_blocked(receiver):
	is_blocked = true


func on_attack_hit(receiver):
	is_hit = true
