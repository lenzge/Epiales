extends PlayerState

func enter():
	player.velocity = Vector2.ZERO


func update(delta):
	# For Example if a plattform breaks
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return

