extends PlayerState

func _ready():
	._ready()
	yield(owner, "ready")


func enter(msg :={}):
	.enter(msg)
	timer.set_wait_time(player.attack_time)
	timer.start()
	# enable the attack hitboxes
	player.get_node("Attack_Down_Ground/HitboxAttack").disabled = false


func exit():
	# disable the attack hitboxes
	player.get_node("Attack_Down_Ground/HitboxAttack").disabled = true


func _on_timeout():
	var input = player.pop_combat_queue()
	player.hitbox_down_attack.knockback_force = 0
	player.hitbox_down_attack.knockback_time = player.attack_knockback[0]
	state_machine.transition_to("Attack_Down_Ground_Recovery")


func physics_update(delta):
	player.crouch_move(delta)
