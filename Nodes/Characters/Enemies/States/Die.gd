extends CharacterState

func _ready():
	processing_mode = 1


func enter(_msg := {}):
	.enter(_msg)
	character.velocity = Vector2.ZERO
	character.hitbox.monitorable = false


func start_animation():
	character.animation.play("Die") 


func _on_timeout():
	character.queue_free()
