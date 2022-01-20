extends AnimationPlayer

export var idle_speed : float = 0.7
export var walk_speed : float = 0.7
export var run_speed_slow : float = 0.5
export var run_speed_fast : float = 1


func _ready():
	animation_set_next("Decelerate","Idle")
	animation_set_next("Run", "Run_loop")
	animation_set_next("Run_Turn", "Run_loop")
	animation_set_next("Jump", "Fall_Long")
	animation_set_next("Fall", "Fall_Long")
	animation_set_next("Crouch_End", "Idle")
	animation_set_next("Crouch_Run", "Run")
	animation_set_next("Crouch_Start", "Crouch")
	animation_set_next("Jump_landing", "Idle")
	
	animation_set_next("Attack_Down_Windup","Attack_Down")
	animation_set_next("Attack_Down","Attack_Down_Recovery")
	animation_set_next("Attack_Down_Recovery", "Crouch")
	
	animation_set_next("Attack_Down_Windup_Air","Attack_Down_Air")
	animation_set_next("Attack_Down_Air","Attack_Down_Recovery_Air")
	
	animation_set_next("Attack_Up_Windup","Attack_Up")
	animation_set_next("Attack_Up","Attack_Up_Recovery")
	
	animation_set_next("Attack_Up_Windup_Air","Attack_Up_Air")
	animation_set_next("Attack_Up_Air","Attack_Up_Recovery_Air")
	
	
	

