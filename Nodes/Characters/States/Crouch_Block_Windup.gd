extends PlayerState


func enter(_msg := {}):
	.enter(_msg)
	.animation_to_timer()
	player.velocity = Vector2.ZERO
	


func update(delta):
	# Action can be cancelled (not by moving)
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Ground_Windup")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")


func physics_update(delta):
	player.crouch_move(delta)


func _on_timeout():
	player.pop_combat_queue()
	state_machine.transition_to("Crouch_Block")
