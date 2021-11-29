extends PlayerState

var timer : Timer

func _ready():
	._ready()
	yield(owner, "ready")
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(player.block_time)
	timer.connect("timeout", self, "_stop_block")
	self.add_child(timer)


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	player.get_node("Crouch_Block/HitboxBlock").disabled = false
	timer.start()


func exit():
	timer.stop()
	player.get_node("Crouch_Block/HitboxBlock").disabled = true


func physics_update(delta):
	player.crouch_move(delta)


func _stop_block():
	state_machine.transition_to("Crouch_Block_Recovery")
