extends PlayerState

## It's basicly the same as the Attack_Basic_Windup state

func _ready():
	._ready()
	yield(owner, "ready")


func enter(msg :={}):
	.enter(msg)
	timer.set_wait_time(player.windup_time)
	timer.start()


func update(delta):
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")
	elif Input.is_action_just_pressed("dash")  and player.can_dash:
		state_machine.transition_to("Dash")


func physics_update(delta):
	player.attack_up_ground_move(delta)


func _stop_attack_windup():
	var input = player.pop_combat_queue()
	if input == null:
		state_machine.transition_to("Idle")
	elif input == player.PossibleInput.ATTACK_BASIC:
		state_machine.transition_to("Attack_Up_Ground")
	elif input == player.PossibleInput.BLOCK:
		state_machine.transition_to("Block_Windup")
