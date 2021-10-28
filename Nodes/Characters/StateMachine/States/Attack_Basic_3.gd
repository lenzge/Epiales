extends PlayerState

var label : Label
var input := []

func enter():
	player.velocity = Vector2.ZERO
	player.attack_basic_3()
	
	label = Label.new()
	label.text = "Attack_Basic_3"
	player.add_child(label)


func update(delta):
	if Input.is_action_just_pressed("attack"):
		input.push_front(1)


func _on_AnimationPlayer_animation_finished(anim_name):
	player.remove_child(label)
	label.queue_free()
	input.clear()
	state_machine.transition_to("Attack_Basic_Recover")
