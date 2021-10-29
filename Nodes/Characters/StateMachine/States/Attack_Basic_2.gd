extends PlayerState

var input := []

func enter():
	player.velocity = Vector2.ZERO
	player.attack_basic_2()


func update(delta):
	if Input.is_action_just_pressed("attack"):
		input.push_front(1)


func _on_Anim_Attack_Basic_2_animation_finished(anim_name):
	if not input.empty():
		if input[0] == 1:
			input.clear()
			state_machine.transition_to("Attack_Basic_3")
		else:
			state_machine.transition_to("Attack_Basic_Recovery")
	else: 
		state_machine.transition_to("Attack_Basic_Recovery")

