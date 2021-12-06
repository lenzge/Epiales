extends PlayerState

func _ready():
	._ready()
	yield(owner, "ready")


func enter(msg :={}):
	.enter(msg)
	timer.set_wait_time(player.attack_time)
	timer.start()
	# enable the attack hitboxes
	player.get_node("Attack_Down_Air/HitboxAttack").disabled = false


func exit():
	# disable the attack hitboxes
	player.get_node("Attack_Down_Air/HitboxAttack").disabled = true


func _on_timeout():
	var input = player.pop_combat_queue()
	
	if input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
	else:
		player.hitbox_down_attack_air.knockback_force = player.attack_force[0]
		player.hitbox_down_attack_air.knockback_time = player.attack_knockback[0]
		#player.hitbox_up_attack_air.is_directed = true
		#player.hitbox_up_attack_air.direction = Vector2(0, -1)
		state_machine.transition_to("Attack_Down_Air_Recovery")


func physics_update(delta):
	player.attack_updown_air_move(delta)
