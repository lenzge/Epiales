extends PlayerState

var timer : Timer

func _ready():
	._ready()
	yield(owner, "ready")
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(player.attack_time)
	timer.connect("timeout", self, "_stop_attack_recovery")
	self.add_child(timer)


func enter(_msg := {}):
	.enter(_msg)
	player.velocity = Vector2.ZERO
	
	timer.start()


func exit():
	timer.stop()


func _stop_attack_recovery():
	state_machine.transition_to("Idle")
