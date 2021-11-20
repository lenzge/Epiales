extends EnemyState

# depending on last state (windup or chase) attack chain is possible
var attack_chain : bool
var attack_count : int = 0
var is_blocked : bool
var is_hit : bool

func enter(_msg := {}):
	.enter(_msg)
	is_blocked = false
	is_hit = false
	if state_machine.last_state.name == "Attack_Windup":
		attack_chain = true
		attack_count = 1
	else:
		attack_count = 0
		attack_chain = false
	timer.set_wait_time(enemy.attack_time)
	timer.start()
	enemy.attack_area.knockback_force = enemy.attack_force[attack_count]
	enemy.attack_area.knockback_time = enemy.attack_knockback[attack_count]


func physics_update(delta):
	enemy.attack_move(delta,attack_chain)


func _on_timeout():
	attack_count += 1
	#if is_blocked:
		#state_machine.transition_to("Stunned")
	if attack_chain and !is_blocked and is_hit and attack_count <= enemy.max_attack_combo:
		is_hit = false
		timer.start()
		enemy.attack_area.knockback_force = enemy.attack_force[attack_count]
		enemy.attack_area.knockback_time = enemy.attack_knockback[attack_count]
	else:
		state_machine.transition_to("Attack_Recovery")


func on_attack_blocked(receiver):
	is_blocked = true


func on_attack_hit(receiver):
	is_hit = true
