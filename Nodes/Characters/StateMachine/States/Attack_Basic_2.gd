extends PlayerState

var label : Label
var input := []

func enter():
	player.velocity = Vector2.ZERO
	player.attack_basic_2()
	
	label = Label.new()
	label.text = "Attack_Basic_2"
	player.add_child(label)


func update(delta):
	if Input.is_action_just_pressed("attack"):
		input.push_front(1)


func _on_Anim_Attack_Basic_2_animation_finished(anim_name):
	player.remove_child(label)
	label.queue_free()
	if not input.empty():
		if input[0] == 1:
			input.clear()
			state_machine.transition_to("Attack_Basic_3")
		else:
			state_machine.transition_to("Attack_Basic_Recover")
	else: 
		state_machine.transition_to("Attack_Basic_Recover")

