extends PlayerState

var label : Label
var input := []

func enter():
	player.velocity = Vector2.ZERO
	player.attack_basic_1()
	
	label = Label.new()
	label.text = "Attack_Basic_1"
	player.add_child(label)
	


func update(delta):
	if Input.is_action_just_pressed("attack"):
		input.push_front(1)
#	# For Example if a plattform breaks
#	if not player.is_on_floor():
#		state_machine.transition_to("Fall")
#		return



func _on_AnimationPlayer_animation_finished(anim_name):
	player.remove_child(label)
	label.queue_free()
	if not input.empty():
		if input[0] == 1:
			input.clear()
			state_machine.transition_to("Attack_Basic_2")
		else:
			state_machine.transition_to("Attack_Basic_Recover")
	else: 
		state_machine.transition_to("Attack_Basic_Recover")
