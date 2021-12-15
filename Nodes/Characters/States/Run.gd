extends PlayerState

var update_count = 0

func enter(msg := {}):
	.enter(msg)
	player.sound_machine.play_sound("Running", true)
	update_count = 0


func exit():
	player.sound_machine.stop_sound("Running")


func update(delta):
	player.sound_machine.randomize_level("Running", -6.0, 3.0)
	player.sound_machine.randomize_pitch("Running", 0.7, 1.5)


func physics_update(delta):
	update_count += 1
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return
		
	player.move(delta)
	# turn?
	if update_count > 1 and not player.direction == player.prev_direction and abs(player.velocity.x) > 60 :
		player.animation_tree.travel("Run_Turn")

	if Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("move_up"):
			state_machine.transition_to("Attack_Up_Ground_Windup")
		else:
			state_machine.transition_to("Attack_Basic_Windup")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("block"):
		state_machine.transition_to("Block_Windup")
	elif player.last_movement_buttons.empty():
		player.last_movement_buttons.clear()
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("dash")  and player.can_dash:
		state_machine.transition_to("Dash")
	elif Input.is_action_pressed("move_down"):
		state_machine.transition_to("Crouch")
		
