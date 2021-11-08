extends EnemyState

var force
var direction
var Stimer : SceneTreeTimer

func enter(_msg := {}):
	.enter(_msg)
	force = _msg.force
	direction = _msg.direction
	enemy.velocity = Vector2.ZERO
	Stimer = get_tree().create_timer(_msg.time)
	yield(Stimer, "timeout")
	
	state_machine.transition_to("Patrol")


func update(delta):
	enemy.knockback(delta, force, direction)
	# Action can't be cancelled
