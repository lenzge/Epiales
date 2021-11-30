extends PlayerState

func _ready():
	._ready()
	yield(owner, "ready")


func enter(msg :={}):
	.enter(msg)
	timer.set_wait_time(player.attack_time)
	timer.start()
	# enable the attack hitboxes
	player.get_node("Attack_Up_Ground/HitboxAttack_Front").disabled = false
	player.get_node("Attack_Up_Ground/HitboxAttack_Top").disabled = false


func exit():
	# disable the attack hitboxes
	player.get_node("Attack_Up_Ground/HitboxAttack_Front").disabled = true
	player.get_node("Attack_Up_Ground/HitboxAttack_Top").disabled = true


func _stop_attack():
	var input = player.pop_combat_queue()
	
	if input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
	else:
		state_machine.transition_to("Attack_Up_Ground_Recovery")


func physics_update(delta):
	player.attack_up_ground_move(delta)
