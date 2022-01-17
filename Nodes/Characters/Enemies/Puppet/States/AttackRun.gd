extends "res://Nodes/Characters/Enemies/States/Run.gd"


func _ready():
	._ready()
	yield(owner, "ready")
	assert("is_winding_up" in character)


func start_animation():
	character.animation.play("AttackRun")


func check_transitions(delta):
	if character.is_winding_up == false:
		state_machine.transition_to("Attack")
	if !character.is_on_floor():
		state_machine.transition_to("AttackFall")


func _on_attack():
	state_machine.transition_to("Attack")
