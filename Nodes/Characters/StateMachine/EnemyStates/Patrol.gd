extends EnemyState

func enter(_msg := {}):
	.enter(_msg)
	enemy.velocity = Vector2.ZERO
	print("lol")

func physics_update(delta):
	if not enemy.is_on_floor():
		state_machine.transition_to("Air")
		return
	enemy.move(delta)
