extends CharacterState

var velocity : Vector2
var direction : float
var enter_time : int
var damage

func enter(_msg := {}):
	velocity = _msg.velocity
	direction = _msg.direction.x
	enter_time = OS.get_ticks_msec()
	damage = _msg.knockback_force


func update(delta):
	# If there is no hit_stop signal from the charged dash hitbox
	if (OS.get_ticks_msec() - enter_time > 1001):
		state_machine.transition_to("Flinch", {"direction_x":direction})

func exit():
	var damage_dealt = int(damage * (OS.get_ticks_msec() - enter_time) / 1000)
	character.health -= damage_dealt
	character.healthbar.get_damage(damage_dealt)
	character.velocity = Vector2.ZERO


func physics_update(delta):
	character.velocity = character.move_and_slide(velocity, Vector2.UP)
