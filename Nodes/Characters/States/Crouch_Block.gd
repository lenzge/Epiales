extends PlayerState

func _ready():
	._ready()
	yield(owner, "ready")


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	player.get_node("Crouch_Block/HitboxBlock").disabled = false
	timer.set_wait_time(player.block_time)
	timer.start()


func exit():
	player.get_node("Crouch_Block/HitboxBlock").disabled = true


func physics_update(delta):
	player.crouch_move(delta)


func _stop_block():
	state_machine.transition_to("Crouch_Block_Recovery")
