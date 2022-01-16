extends "res://Nodes/Characters/Enemies/States/Run.gd"

# for finding the right animation
var loop := false

func _ready():
	yield(owner, "ready")
	assert("is_winding_up" in character)


func check_transitions(_delta):
	.check_transitions(_delta)
	if character.is_winding_up:
		state_machine.transition_to("AttackWindUp")


func update_animation(delta):
	if not is_equal_approx(character.get_move().x, 0.0):
		if character.is_running and not loop:
			loop = true
			character.animation.play("Run_Start")
		elif not character.is_running and not loop:
			loop = true
			character.animation.play("Walk_Start")
		if character.is_facing_right && character.get_move().x < 0.0 || !character.is_facing_right && character.get_move().x  > 0.0:
			character.flip()
	else:
		if character.animation.current_animation == "Walk_Loop":
			loop = false
			character.animation.play("Walk_End")
		elif character.animation.current_animation == "Run_Loop":
			loop = false
			character.animation.play("Run_End")

func start_animation():
	.start_animation()
	loop = false
	
func on_attack():
	state_machine.transition_to("AttackWindUp")
