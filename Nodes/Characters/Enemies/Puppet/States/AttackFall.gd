extends CharacterState


func _ready():
	yield(owner, "ready")
	assert("is_winding_up" in character)


func start_animation():
	character.animation.play("AttackFall")


func check_transitions(delta):
	if character.is_winding_up == false:
		state_machine.transition_to("Attack")
	if character.is_on_floor():
		state_machine.transition_to("AttackRun")


func _on_attack():
	state_machine.transition_to("Attack")
