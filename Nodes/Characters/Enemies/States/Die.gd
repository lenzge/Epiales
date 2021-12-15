extends CharacterState

func enter(_msg := {}):
	.enter(_msg)
	character.velocity = Vector2.ZERO
	character.animation.play("Die")
	timer.start(character.dying_time)

func _on_timeout():
	character.queue_free()
