extends CharacterState

export var flinch_intensity : float = 100

var direction_x : float

func _ready():
	yield(owner, "ready")


func enter(_msg := {}):
	.enter(_msg)
	character.can_die = false
	character.velocity = Vector2.ZERO
	direction_x = _msg.direction_x


func start_animation():
	.start_animation()
	character.animation.play("Flinch")
	if character.is_facing_right && direction_x > 0.0 || !character.is_facing_right && direction_x < 0.0:
		character.flip()


func update(delta):
	.update(delta)
	character.move_and_slide(Vector2(flinch_intensity * direction_x, 0.0), Vector2.UP)


func exit():
	.exit()
	character.can_die = true


func _on_timeout():
	state_machine.transition_to("Run")
