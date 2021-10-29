extends PlayerState

var input := []

func enter():
	player.velocity = Vector2.ZERO
	player.attack_basic_3()
	


func update(delta):
	if Input.is_action_just_pressed("attack"):
		input.push_front(1)


func _on_AnimationPlayer_animation_finished(anim_name):
	input.clear()
	state_machine.transition_to("Attack_Basic_Recovery")
