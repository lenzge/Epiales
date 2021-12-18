extends CharacterState

func enter(_msg := {}):
	.enter(_msg)
	character.velocity = Vector2.ZERO
	character.hitbox.set_disabled(true)


func start_animation():
	character.animation.play("Die") 


func _on_timeout():
	character.queue_free()
