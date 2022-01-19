extends EnemyState

var velocity : Vector2


func enter(_msg := {}):
	velocity = _msg.velocity


func exit():
	pass


func physics_update(delta):
	enemy.velocity = enemy.move_and_slide(velocity, Vector2.UP)
