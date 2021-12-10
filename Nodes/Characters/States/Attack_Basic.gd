extends PlayerState

var attack_count := 1 # Needs to be 1 because increment happens after the attack

func enter(_msg := {}):
	.enter(_msg)
	if player.in_charged_attack:
		attack_count = 4	# for getting the fourth entry of the arrays
		timer.set_wait_time(player.charged_attack_time)
		_set_hitbox(1)
	else:
		timer.set_wait_time(player.attack_time)
	timer.start()
	player.hitbox_attack.knockback_force = player.attack_force[attack_count -1]
	player.hitbox_attack.knockback_time = player.attack_knockback[attack_count -1]


func physics_update(delta):
	player.attack_move(delta)


func _on_timeout():
	# Transition to next state
	var input = player.last_input.back()
	print("[DEBUG] @class: ", self.name, " input: ", input)
	if player.in_charged_attack:
		player.in_charged_attack = false
		_set_hitbox(-1)
	elif input == player.PossibleInput.ATTACK_BASIC and attack_count < player.max_attack_combo:
		attack_count += 1
		state_machine.transition_to("Attack_Basic_Windup")
	elif input == player.PossibleInput.BLOCK:
		attack_count = 1
		player.pop_combat_queue()
		state_machine.transition_to("Block_Windup")
	else:
		attack_count = 1
		state_machine.transition_to("Attack_Basic_Recovery")


func _set_hitbox(to_charged):
	var position = 40
	var scale = 3
	player.hitbox_attack.position.x = player.hitbox_attack.position.x + position * player.direction * to_charged
	player.hitbox_attack.scale.x = player.hitbox_attack.scale.x + scale * to_charged
