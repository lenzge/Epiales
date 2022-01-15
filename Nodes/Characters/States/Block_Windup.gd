extends PlayerState

# Windup before blocking. Only available on ground

func enter(_msg := {}):
	.enter(_msg)
	.animation_to_timer()

# 'Movement' and checking for escape conditions
func physics_update(delta):
	# For smooth deceleration after moving
	player.decelerate_move_ground(delta)
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("attack"):
		if Input.is_action_pressed("move_up"):
			state_machine.transition_to("Attack_Up_Windup")
		else:
			state_machine.transition_to("Attack_Basic_Windup")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")


func _on_timeout():
	player.pop_combat_queue()
	state_machine.transition_to("Block")
