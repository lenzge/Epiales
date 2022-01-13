extends PlayerState

func enter(msg :={}):
	.enter(msg)

func exit():
	.exit()

func animation_transition():
	animationPlayer.play("Crouch_End")
	yield(animationPlayer, "crouch_finished")
	.animation_transition()

func update(delta):
	if abs(player.velocity.x) > 100:
		animationPlayer.play("Slide")
	elif animationPlayer.current_animation == "Slide":
		animationPlayer.play("Slide_Crouch")
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack_Down_Ground_Windup")
	elif !Input.is_action_pressed("move_down") and not player.last_movement_buttons.empty():
		state_machine.transition_to("Run")
	elif !Input.is_action_pressed("move_down"):
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")


func physics_update(delta):
	player.crouch_move(delta)

	
