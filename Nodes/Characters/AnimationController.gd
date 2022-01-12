extends AnimationPlayer

export var idle_speed : float = 0.7
export var walk_speed : float = 0.7
export var run_speed_slow : float = 0.5
export var run_speed_fast : float = 1


func _ready():
	animation_set_next("Run_Turn","Idle")
	animation_set_next("Run", "Run_loop")
	animation_set_next("Jump", "Fall_Long")
	animation_set_next("Fall", "Fall_Long")
	animation_set_next("Crouch_End", "Idle")
	animation_set_next("Crouch_Run", "Run")
	animation_set_next("Jump_landing", "Idle")
	
	

