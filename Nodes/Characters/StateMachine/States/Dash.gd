extends PlayerState

func enter(_msg := {}):
	.enter(_msg)
	player.hitbox.get_child(0).disabled = true
	timer.set_wait_time(player.dash_time)
	timer.start()
	# todo: change player hitbox so player can deal damage while dashing


func physics_update(delta):
	player.dash_move(delta)


func exit():
	player.hitbox.get_child(0).disabled = false
	timer.stop()


func _on_timeout() -> void:
	if player.last_movement_buttons.empty():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Run")
