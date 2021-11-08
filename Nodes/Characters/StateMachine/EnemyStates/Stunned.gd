extends EnemyState

var force
var direction

func enter(_msg := {}):
	.enter(_msg)
	force = _msg.force
	direction = _msg.direction
	enemy.velocity = Vector2.ZERO
	timer.set_wait_time(_msg.time)
	print(timer.wait_time)
	timer.connect("timeout", self, "_on_timeout")
	timer.start()
	

func update(delta):
	enemy.knockback(delta, force, direction)
	# Action can't be cancelled
	
func _on_timeout():
	state_machine.transition_to("Patrol")
