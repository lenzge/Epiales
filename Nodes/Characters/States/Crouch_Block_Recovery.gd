extends PlayerState

func _ready():
	._ready()
	yield(owner, "ready")


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	timer.set_wait_time(player.attack_time)
	timer.start()


func physics_update(delta):
	player.crouch_move(delta)


func _stop_block_recovery():
	state_machine.transition_to("Crouch")

