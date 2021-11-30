extends PlayerState

func _ready():
	._ready()
	yield(owner, "ready")


func enter(msg :={}):
	.enter(msg)
	timer.set_wait_time(player.recovery_time)
	timer.start()


func physics_update(delta):
	player.attack_up_ground_move(delta)


func _stop_attack_recovery():
	state_machine.transition_to("Idle")
